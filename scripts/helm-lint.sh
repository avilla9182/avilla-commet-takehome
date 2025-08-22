#!/bin/bash
# Helm chart validation and linting script

set -euo pipefail

CHART_DIR="./charts/hello-world"
RELEASE_NAME="test-release"

echo "=== Helm Chart Validation ==="

# 1. Lint the chart
echo "🔍 Linting Helm chart..."
helm lint "$CHART_DIR"

# 2. Validate chart dependencies
echo "📦 Checking chart dependencies..."
helm dependency build "$CHART_DIR"
helm dependency list "$CHART_DIR"

# 3. Template validation (dry-run)
echo "📝 Validating chart templates..."
helm template "$RELEASE_NAME" "$CHART_DIR" --dry-run

# 4. Validate against different Kubernetes versions
echo "🔧 Testing against different K8s versions..."
for version in "1.25" "1.26" "1.27"; do
  echo "  Testing K8s $version..."
  helm template "$RELEASE_NAME" "$CHART_DIR" --kube-version "$version" --dry-run > /dev/null
done

# 5. Validate with different value combinations
echo "⚙️ Testing different value combinations..."
helm template "$RELEASE_NAME" "$CHART_DIR" --set replicaCount=3 --dry-run > /dev/null
helm template "$RELEASE_NAME" "$CHART_DIR" --set redis.enabled=false --dry-run > /dev/null

echo "✅ All Helm validations passed!"
