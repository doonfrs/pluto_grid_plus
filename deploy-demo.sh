#!/bin/bash

# Exit immediately if a command fails
set -e

# Define variables
BRANCH="gh-pages"
DEMO_DIR="demo"
BUILD_DIR="$DEMO_DIR/build/web"

echo "🚀 Starting Flutter Web Build Process from '$DEMO_DIR'..."

# Ensure we are on the master branch
git checkout master

# Pull the latest changes
git pull origin master

# Navigate to demo directory
cd $DEMO_DIR

# Get dependencies
flutter pub get

# Build the Flutter web app
flutter build web --release

# Move back to the root directory
cd ..

echo "✅ Flutter Web Build Completed!"

# Switch to gh-pages branch (or create it if it doesn't exist)
if git rev-parse --verify $BRANCH >/dev/null 2>&1; then
    git checkout $BRANCH
else
    git checkout --orphan $BRANCH
    git rm -rf .
fi

echo "🔁 Moving demo build files to the repository root..."

# Remove old files and copy new build files
rm -rf *
cp -r $BUILD_DIR/* .
cp -r $BUILD_DIR/. .

# Add and commit changes
git add .
git commit -m "🚀 Deploy updated Flutter Web Demo"

# Push to the gh-pages branch
git push -f origin $BRANCH

# Switch back to master
git checkout master

echo "🎉 Deployment completed!"
