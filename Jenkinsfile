// CI/CD pipeline: Checkout -> Lint -> Test -> Build -> Terraform (validate/plan) -> Provision -> Deploy
// Student: Aditya Ubale | PRN: 202301040111
pipeline {
    agent any

    triggers {
        // Poll GitHub for new commits every ~5 minutes (a webhook can replace this)
        pollSCM('H/5 * * * *')
    }

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        APP_NAME                  = 'inventory-api'
        TF_IN_AUTOMATION          = 'true'
        // Offline mode so that the AWS plan works without an AWS account.
        // For real provisioning remove these and use credentials from the Jenkins credential store.
        TF_VAR_offline_validation = 'true'
        AWS_ACCESS_KEY_ID         = 'dummy'
        AWS_SECRET_ACCESS_KEY     = 'dummy'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Student: Aditya Ubale | PRN: 202301040111'
                sh 'git log -1 --oneline'
                sh 'node --version'
            }
        }

        stage('Lint') {
            steps {
                sh '''
                    for f in src/*.js; do
                        node --check "$f" && echo "Syntax OK: $f"
                    done
                '''
            }
        }

        stage('Unit Test') {
            steps {
                sh '''
                    node --test \
                        --test-reporter=spec --test-reporter-destination=stdout \
                        --test-reporter=junit --test-reporter-destination=test-results.xml
                    node scripts/fix_junit.js test-results.xml
                '''
            }
            post {
                always { junit 'test-results.xml' }
            }
        }

        stage('Build') {
            steps {
                sh '''
                    mkdir -p build
                    tar -czf build/${APP_NAME}-${BUILD_NUMBER}.tar.gz src package.json
                    ls -lh build
                    sha256sum build/${APP_NAME}-${BUILD_NUMBER}.tar.gz
                '''
                archiveArtifacts artifacts: 'build/*.tar.gz', fingerprint: true
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform/aws') {
                    sh 'terraform version'
                    sh 'terraform init -input=false -backend=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check -recursive -diff || echo "Formatting differences found (non-blocking)"'
                }
                dir('terraform/aws') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan (AWS)') {
            steps {
                dir('terraform/aws') {
                    sh 'terraform plan -input=false -no-color -var-file=envs/dev.tfvars -out=tfplan'
                    sh 'terraform show -no-color tfplan > plan-dev.txt'
                }
                archiveArtifacts artifacts: 'terraform/aws/plan-dev.txt', fingerprint: true
            }
        }

        stage('Provision Environment (Terraform apply)') {
            steps {
                dir('terraform/local-demo') {
                    sh 'terraform init -input=false'
                    sh 'terraform apply -input=false -auto-approve -no-color -var "build_number=${BUILD_NUMBER}" -var "deploy_root=${WORKSPACE}/deploy/staging"'
                    sh 'terraform output'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'bash scripts/deploy.sh "${BUILD_NUMBER}" "${WORKSPACE}/deploy/staging"'
            }
        }
    }

    post {
        success { echo 'Pipeline finished successfully: code built, tested, infrastructure provisioned and application deployed.' }
        failure { echo 'Pipeline failed - check the stage logs.' }
    }
}
