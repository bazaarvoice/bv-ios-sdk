#!/bin/sh

# This causes the script to fail if any subscript fails
set -e
set -o pipefail

echo "Building stand-alone bvpixel"

cd "$(dirname "$0")"

xcodebuild build -project ./bvpixel.xcodeproj -scheme bvpixel -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 12,OS=latest'
