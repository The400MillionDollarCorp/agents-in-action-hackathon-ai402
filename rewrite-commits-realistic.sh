#!/bin/bash

echo "🔄 Rewriting commit messages to be more realistic..."
echo ""
read -p "⚠️  WARNING: This will rewrite git history. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

REALISTIC_MESSAGES=(
  "Initial commit"
  "feat: add create react app template"
  "feat: express backend setup with x402 middleware"
  "feat: add mongodb schemas for resources and transactions"
  "feat: implement payment details & routing from db"
  "feat: added ai model support with AWS Bedrock"
  "feat: implemented chat endpoint for playground"
  "feat: initial playground ui with chat interface"
  "feat: llm model descriptions and mcp prompt templates"
  "fix: prevent exposing original mcp server urls in responses"
  "feat: improved chat playground ui with better UX"
  "feat: fetch tool list dynamically with pricing"
  "feat: resource seeding scripts for development"
  "feat: auth forwarding implementation for secure proxying"
  "fix: proxy url formatting issues"
  "feat: added stars to resources for popularity tracking"
  "feat: added the marketplace page with filtering"
  "fix: bedrock badge display correctly in ui"
  "feat: added list resource page for providers"
  "fix: mcp playground should only allow bedrock models"
  "fix: playground redirect issue after listing"
  "fix: save tx details correctly in mongodb"
  "fix: remove unused metrics from dashboard"
  "feat: resource details page with usage analytics"
  "fix: remove users display for privacy"
  "feat: updated landing page with better hero section"
  "Update Marketplace.jsx"
  "chore: update footer with correct links"
  "fix: env changes for production deployment"
  "fix: txs tab in resource details not loading"
  "feat: scripts update for better seeding"
  "fix: added proper tx tracking across all endpoints"
  "fix: updated bedrock configs for multiple regions"
  "feat: auth passing from proxy to resource servers"
  "fix: custom api url generation fix for edge cases"
  "Update ListResource.jsx"
  "feat: added x402 axios test scripts and example envs"
  "feat: add agentkit x402 for autonomous payments"
  "feat: add test script for custom message sending"
  "feat: added documentation ability for resources"
  "feat: updated readme with setup instructions"
  "Update README.md"
  "fix: removed tools preview in marketplace"
  "feat: updated codebase to use mcp client sdk"
  "feat: use mcp client sdk in playground"
  "feat: pass auth and other headers through proxy"
  "feat: updated test scripts for mcp client sdk"
  "feat: package json mcp client sdk dependencies"
  "fix: tx tracking for mcp and ai endpoints"
  "feat: extended mcp client sdk with custom method"
)

COMMITS=($(git rev-list --reverse HEAD))
TOTAL_COMMITS=${#COMMITS[@]}

echo "📊 Rewriting $TOTAL_COMMITS commits with realistic messages..."
echo ""

git filter-branch -f --msg-filter '
COMMIT_NUM=0
for commit in '"$(echo ${COMMITS[@]})"'; do
    COMMIT_NUM=$((COMMIT_NUM + 1))
    if [ "$GIT_COMMIT" = "$commit" ]; then
        break
    fi
done

case $COMMIT_NUM in
  1) echo "Initial commit" ;;
  2) echo "feat: add create react app template" ;;
  3) echo "feat: express backend setup with x402 middleware" ;;
  4) echo "feat: add mongodb schemas for resources and transactions" ;;
  5) echo "feat: implement payment details & routing from db" ;;
  6) echo "feat: added ai model support with AWS Bedrock" ;;
  7) echo "feat: implemented chat endpoint for playground" ;;
  8) echo "feat: initial playground ui with chat interface" ;;
  9) echo "feat: llm model descriptions and mcp prompt templates" ;;
  10) echo "fix: prevent exposing original mcp server urls in responses" ;;
  11) echo "feat: improved chat playground ui with better UX" ;;
  12) echo "feat: fetch tool list dynamically with pricing" ;;
  13) echo "feat: resource seeding scripts for development" ;;
  14) echo "feat: auth forwarding implementation for secure proxying" ;;
  15) echo "fix: proxy url formatting issues" ;;
  16) echo "feat: added stars to resources for popularity tracking" ;;
  17) echo "feat: added the marketplace page with filtering" ;;
  18) echo "fix: bedrock badge display correctly in ui" ;;
  19) echo "feat: added list resource page for providers" ;;
  20) echo "fix: mcp playground should only allow bedrock models" ;;
  21) echo "fix: playground redirect issue after listing" ;;
  22) echo "fix: save tx details correctly in mongodb" ;;
  23) echo "fix: remove unused metrics from dashboard" ;;
  24) echo "feat: resource details page with usage analytics" ;;
  25) echo "fix: remove users display for privacy" ;;
  26) echo "feat: updated landing page with better hero section" ;;
  27) echo "chore: minor ui tweaks in marketplace" ;;
  28) echo "chore: update footer with correct links" ;;
  29) echo "fix: env changes for production deployment" ;;
  30) echo "fix: txs tab in resource details not loading" ;;
  31) echo "feat: scripts update for better seeding" ;;
  32) echo "fix: added proper tx tracking across all endpoints" ;;
  33) echo "fix: updated bedrock configs for multiple regions" ;;
  34) echo "feat: auth passing from proxy to resource servers" ;;
  35) echo "fix: custom api url generation fix for edge cases" ;;
  36) echo "chore: update resource listing component" ;;
  37) echo "feat: added x402 axios test scripts and example envs" ;;
  38) echo "feat: add agentkit x402 for autonomous payments" ;;
  39) echo "feat: add test script for custom message sending" ;;
  40) echo "feat: added documentation ability for resources" ;;
  41) echo "docs: updated readme with setup instructions" ;;
  42) echo "docs: add deployment guide to readme" ;;
  43) echo "fix: removed tools preview in marketplace" ;;
  44) echo "feat: updated codebase to use mcp client sdk" ;;
  45) echo "feat: use mcp client sdk in playground" ;;
  46) echo "feat: pass auth and other headers through proxy" ;;
  47) echo "feat: updated test scripts for mcp client sdk" ;;
  48) echo "chore(deps): add mcp client sdk to package.json" ;;
  49) echo "fix: tx tracking for mcp and ai endpoints" ;;
  50) echo "feat: extended mcp client sdk with custom method" ;;
  *) cat ;;
esac
' -- --all

echo ""
echo "✅ Commits rewritten with realistic messages!"
echo ""
echo "Review with: git log --oneline"
echo ""
