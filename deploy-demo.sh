#!/bin/bash

set -e

BRANCH="gh-pages"
DEMO_DIR="demo"
BUILD_DIR="$DEMO_DIR/build/web"

echo "🚀 Starting Flutter Web Build Process from '$DEMO_DIR'..."

git checkout master
git pull origin master

cd $DEMO_DIR

flutter pub get
flutter build web --release

cd ..

echo "✅ Flutter Web Build Completed!"
if git rev-parse --verify $BRANCH >/dev/null 2>&1; then
    git checkout $BRANCH
else
    git checkout --orphan $BRANCH
    git commit --allow-empty -m "Initial commit for GitHub Pages"
fi

echo "🧹 Cleaning up old files while keeping .git..."
git rm -rf . >/dev/null 2>&1

echo "🔁 Moving demo build files to the repository root..."
cp -r $BUILD_DIR/* .
cp -r $BUILD_DIR/. .
rm -rf demo

git add .
git commit -m "🚀 Deploy updated Flutter Web Demo"

git push -f origin $BRANCH

git checkout master

echo "🎉 Deployment completed!"
