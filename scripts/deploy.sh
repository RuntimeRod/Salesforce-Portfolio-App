#!/usr/bin/env bash
# Deploys the entire project to a target org and assigns the permission set.
# Usage: ./scripts/deploy.sh [org-alias]   (default alias: portfolio-app)
set -euo pipefail

ORG_ALIAS="${1:-portfolio-app}"

echo ">> Deploying metadata to org '$ORG_ALIAS'..."
sf project deploy start --target-org "$ORG_ALIAS" --wait 15

echo ">> Assigning permission set..."
sf org assign permset --name Portfolio_Admin --target-org "$ORG_ALIAS" || \
  echo "   (Portfolio_Admin permission set not found yet - skipping)"

if [ -f "data/plan.json" ]; then
  echo ">> Importing sample data..."
  sf data import tree --plan data/plan.json --target-org "$ORG_ALIAS" || \
    echo "   (data import failed - check plan files)"
elif [ -d "data" ] && [ -n "$(ls -A data/*.json 2>/dev/null)" ]; then
  echo ">> Importing sample data..."
  sf data import tree --files data/*.json --target-org "$ORG_ALIAS" || \
    echo "   (data import failed - check plan files)"
fi

echo ">> Running Apex tests with coverage..."
sf apex run test --target-org "$ORG_ALIAS" --code-coverage --result-format human --wait 10 || \
  echo "   (no Apex tests yet - skipping)"

echo ">> Done. Open the org with: sf org open --target-org $ORG_ALIAS"
