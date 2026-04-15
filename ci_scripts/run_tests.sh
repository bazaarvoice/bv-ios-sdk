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
  	exit $?
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT


echo "Starting run_tests script"
set -euf -o pipefail


./print_time.sh &
pid=$!
echo "my pid: $pid"


echo "Installing cocoapods dependencies for BVSDK Test target"
pod install


echo Running tests
xcodebuild test -workspace ../BVSDK.xcworkspace -scheme "BVSDK-Tests" GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS BV_IGNORE_TESTING_STUBS=1' -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 12,OS=latest' | xcpretty -c


cleanup
