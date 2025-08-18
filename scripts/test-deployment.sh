#!/bin/bash
# Automated test script for Helm chart deployment

set -euo pipefail  # Exit on errors and undefined variables

RELEASE_NAME="hello-world-test-$(date +%Y%m%d%H%M%S)"
CHART_DIR="./charts/hello-world"
REDIS_PASSWORD=${REDIS_PASSWORD:-"testpass"}

echo "=== Starting test for release: $RELEASE_NAME ==="

# Install chart with Redis
echo -e "\nInstalling Helm chart..."
helm upgrade --install $RELEASE_NAME $CHART_DIR \
  --set redis.auth.password=$REDIS_PASSWORD \
  --atomic --timeout 5m0s

# Run Helm tests
echo -e "\nRunning Helm tests..."
helm test $RELEASE_NAME --timeout 300s

# Verify Redis connection
echo -e "\nTesting Redis connection..."
REDIS_POD=$(kubectl get pod -l app.kubernetes.io/name=redis -o jsonpath='{.items[0].metadata.name}')
kubectl exec $REDIS_POD -- redis-cli -a $REDIS_PASSWORD ping | grep -q "PONG" || {
  echo "❌ Redis connection failed"
  exit 1
}

# Verify web service
echo -e "\nTesting web service..."
kubectl port-forward svc/$RELEASE_NAME 8080:80 &
PORT_FORWARD_PID=$!
sleep 3  # Wait for port-forward to establish

curl -s http://localhost:8080 | grep -q "Hello World" || {
  echo "❌ Service test failed"
  kill $PORT_FORWARD_PID
  exit 1
}

kill $PORT_FORWARD_PID

# Clean up
echo -e "\nCleaning up..."
helm uninstall $RELEASE_NAME

echo -e "\n✅ All tests passed successfully!"
exit 0
