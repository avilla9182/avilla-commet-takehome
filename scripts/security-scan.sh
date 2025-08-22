#!/bin/bash
# Security scanning script for application and infrastructure

set -euo pipefail

echo "=== Security Scanning ==="

# 1. Check for secrets in code
echo "🔐 Scanning for secrets in code..."
if grep -r -i "password\|secret\|token\|key" . --exclude-dir={.git,node_modules,.terraform,artifacts} | grep -v "example\|test\|dummy"; then
  echo "⚠️  Potential secrets found in code"
  exit 1
fi

# 2. Check Dockerfile security
echo "🐳 Checking Dockerfile security..."
if [ -f "app/Dockerfile" ]; then
  # Check for root user
  if grep -q "USER root" app/Dockerfile; then
    echo "⚠️  Dockerfile runs as root user"
  fi
  
  # Check for latest tags
  if grep -q ":latest" app/Dockerfile; then
    echo "⚠️  Dockerfile uses latest tag"
  fi
fi

# 3. Check Helm chart security
echo "⚓ Checking Helm chart security..."
if [ -f "charts/hello-world/values.yaml" ]; then
  # Check for default passwords
  if grep -q "password.*default" charts/hello-world/values.yaml; then
    echo "⚠️  Default passwords found in values.yaml"
  fi
fi

# 4. Check Terraform security
echo "🏗️ Checking Terraform security..."
if [ -f "infra/main.tf" ]; then
  # Check for hardcoded secrets
  if grep -q "password.*=.*\".*\"" infra/main.tf; then
    echo "⚠️  Hardcoded secrets found in Terraform"
  fi
fi

# 5. Check for outdated dependencies
echo "📦 Checking for outdated dependencies..."
if command -v trivy &> /dev/null; then
  echo "Running Trivy vulnerability scan..."
  trivy fs . --severity HIGH,CRITICAL --exit-code 1 || true
else
  echo "Trivy not installed, skipping vulnerability scan"
fi

echo "✅ Security scan completed!"
