# Jenkins CI/CD + Terraform Mini Project
**Name:** Aditya Ubale | **PRN:** 202301040111

- `src/`, `test/`  Inventory API (Node.js, no dependencies) and unit tests
- `Jenkinsfile`    Checkout -> Lint -> Unit Test -> Build -> Terraform validate/plan -> Provision (apply) -> Deploy
- `terraform/modules/web_server`  reusable AWS module (EC2 + security group)
- `terraform/aws`  root configuration using the module (dev / prod via tfvars)
- `terraform/local-demo`  real provisioning (init/plan/apply/destroy) of a deployment environment, no cloud needed
- `jenkins/`       Dockerfile + Configuration-as-Code for a pre-configured Jenkins
- `scripts/`       deploy script and JUnit helper

Run: GitHub -> Actions -> "Jenkins CI/CD and Terraform Mini Project" -> Run workflow.
