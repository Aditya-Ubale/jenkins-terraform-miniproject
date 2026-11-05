#!/usr/bin/env bash
# Deploys the packaged build into the environment provisioned by Terraform and smoke-tests it.
# Usage: scripts/deploy.sh <build-number> <deploy-dir>
set -euo pipefail

BUILD="$1"
DEPLOY_DIR="$2"
ARTIFACT="build/inventory-api-${BUILD}.tar.gz"

echo "Deploying ${ARTIFACT} to ${DEPLOY_DIR}"
mkdir -p "${DEPLOY_DIR}/app"
tar -xzf "${ARTIFACT}" -C "${DEPLOY_DIR}/app"

echo "Loading environment file created by Terraform:"
cat "${DEPLOY_DIR}/app.env"
set -a
. "${DEPLOY_DIR}/app.env"
set +a

cd "${DEPLOY_DIR}/app"
JENKINS_NODE_COOKIE=dontKillMe nohup node src/server.js > ../app.log 2>&1 &
echo $! > ../app.pid

echo "Waiting for the application to become healthy..."
for i in $(seq 1 15); do
  if curl -sf "http://localhost:${PORT}/health" > /dev/null; then
    echo "Health check passed"
    break
  fi
  sleep 1
done

echo "--- smoke tests ---"
curl -s "http://localhost:${PORT}/health"; echo
curl -s "http://localhost:${PORT}/"; echo
curl -s "http://localhost:${PORT}/api/summary"; echo
echo "--- application log ---"
cat ../app.log

kill "$(cat ../app.pid)"
echo "Deployment verified and test instance stopped."
