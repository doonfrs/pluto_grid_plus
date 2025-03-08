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
flutter build web --release
cd ..

echo "Build Completed!"

git checkout $BRANCH

echo "Preventing build folder from being deleted..."
mv $BUILD_DIR /tmp/build_web

echo "Cleaning old deployment files..."
rm -rf ../pluto_grid_plus/*
rm -rf .dart_tool

echo "🔁 Moving demo build files to the repository root..."
mv /tmp/build_web/* .

rm -rf /tmp/build_web

git add .
git commit -m "🚀 Deploy updated Flutter Web Demo"
git push origin $BRANCH

git checkout master

flutter pub get
cd demo
flutter pub get
cd ..
cd packages/pluto_grid_plus_export
flutter pub get
cd ..
cd ..

echo "🎉 Deployment Completed!"
