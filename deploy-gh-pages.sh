#!/bin/bash
# Deploy receipt dashboard to GitHub Pages
# Usage: ./deploy-gh-pages.sh <github-token>

set -e

if [ -z "$1" ]; then
  echo "Usage: ./deploy-gh-pages.sh <github-personal-access-token>"
  echo "Get token at: https://github.com/settings/tokens (needs 'repo' scope)"
  exit 1
fi

TOKEN="$1"
REPO_DIR="/tmp/receipt-app"

echo "🔐 Authenticating with GitHub..."
echo "$TOKEN" | gh auth login --with-token
gh auth setup-git

echo "📦 Creating repository shadkonstantin1/receipt-app..."
cd "$REPO_DIR"
gh repo create shadkonstantin1/receipt-app --public --source=. --remote=origin --push

echo "🌐 Enabling GitHub Pages..."
gh api repos/shadkonstantin1/receipt-app/pages \
  -X POST \
  -F "source[branch]=master" \
  -F "source[path]=/" 2>/dev/null || \
gh api repos/shadkonstantin1/receipt-app/pages \
  -X PUT \
  -F "source[branch]=master" \
  -F "source[path]=/"

echo ""
echo "✅ Done! Your dashboard will be available at:"
echo "   https://shadkonstantin1.github.io/receipt-app/"
echo ""
echo "   ⚠️  It may take 1-2 minutes for GitHub Pages to deploy."
echo ""
echo "   To test: open in Telegram bot → Menu → Open App"
echo "   URL: https://shadkonstantin1.github.io/receipt-app/"
