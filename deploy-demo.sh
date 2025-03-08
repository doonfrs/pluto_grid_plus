#!/bin/bash

set -e

BRANCH="gh-pages"
DEMO_DIR="demo"
BUILD_DIR="$DEMO_DIR/build/web"

echo "🚀 Building Flutter Web Demo..."

git checkout master
git pull origin master

cd $DEMO_DIR
flutter pub get
flutter build web --release --base-href=/pluto_grid_plus/
cd ..

echo "✅ Build Completed!"

if git rev-parse --verify $BRANCH >/dev/null 2>&1; then
    git checkout $BRANCH
    git pull origin $BRANCH
else
    git checkout --orphan $BRANCH
fi

git rm -rf . >/dev/null 2>&1
cp -r $BUILD_DIR/* .
cp -r $BUILD_DIR/. .

git add .
git commit -m "🚀 Deploy updated Flutter Web Demo"
git push origin $BRANCH # No force push unless necessary!

git checkout master

echo "🎉 Deployment Completed!"
