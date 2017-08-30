#!/bin/bash

cd "$(dirname "$0")"

cleanup() {
	kill -9 $pid
}
control_c()
# run if user hits control-c
{
	echo 'exiting...'
	cleanup
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT


echo "Starting run_tests script"
set -euf -o pipefail



./print_time.sh &
pid=$!
echo "my pid: $pid"

echo Starting build of BVSDKDemo...
set -euf -o pipefail

echo Installing cocoapods dependencies for the BVSDKDemo...
cd ../Examples/BVSDKDemo
pod install --repo-update
cd ../..


echo Staring build...
xcodebuild -workspace ./Examples/BVSDKDemo/BVSDKDemo.xcworkspace -scheme "BVSDKDemo" -sdk iphonesimulator | xcpretty -c

cleanup
