#!/bin/sh

# This causes the script to fail if any subscript fails
set -e
set -o pipefail

echo "Building stand-alone bvpixel..."

#gem install xcpretty --no-ri --no-rdoc

TESTDIR="$(cd $(dirname $0); pwd)"
cd $TESTDIR

xcodebuild build -project "${TESTDIR}/bvpixel.xcodeproj" -scheme bvpixel -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest'
