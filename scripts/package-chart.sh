#!/bin/bash
# Robust Helm chart packaging script with safe variable handling

set -euo pipefail

# Configuration
ARTIFACT_DIR="./artifacts"
CHART_DIR="./charts/hello-world"

# Clean previous artifacts
rm -rf "$ARTIFACT_DIR" ./temp-chart
mkdir -p "$ARTIFACT_DIR"

# 1. Package the chart
echo "📦 Packaging Helm chart..."
helm package "$CHART_DIR" -d "$ARTIFACT_DIR"

# 2. Create repository index with safe URL detection
echo "📝 Generating repository index..."
REPO_URL=""

# Try GitHub Actions environment first
if [[ -n "${GITHUB_REPOSITORY:-}" ]]; then
  REPO_URL="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/main/artifacts"
else
  # Fallback to git remote detection
  if git remote -v >/dev/null 2>&1; then
    REPO_URL="https://raw.githubusercontent.com/$(git remote get-url origin | sed -E 's/.*github.com[:\/]([^/]+\/[^/]+).*/\1/')/main/artifacts"
  else
    echo "⚠️ Warning: Could not determine repository URL"
    echo "Using local path instead"
    REPO_URL="file://$(pwd)/artifacts"
  fi
fi

helm repo index "$ARTIFACT_DIR" --url "$REPO_URL"

# 3. Verify the package
echo "🔍 Verifying package contents..."
LATEST_CHART=$(ls -t "$ARTIFACT_DIR"/hello-world-*.tgz | head -1)
mkdir -p temp-chart
tar -xzf "$LATEST_CHART" -C temp-chart

echo -e "\n📂 Package contents:"
tree temp-chart/hello-world

# 4. Validate the chart
echo -e "\n🧐 Linting chart..."
helm lint temp-chart/hello-world

# Cleanup
rm -rf temp-chart

echo -e "\n✅ Successfully packaged: $(basename "$LATEST_CHART")"
echo "📌 Repository URL: $REPO_URL"

# Pause if running interactively
if [ -t 1 ]; then
  read -rp "Press any key to continue..." -n1 -s
  echo
fi
