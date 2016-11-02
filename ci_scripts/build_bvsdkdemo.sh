echo Starting build of BVSDKDemo...
set -euf -o pipefail

echo Installing cocoapods dependencies for the BVSDKDemo...
cd ./Examples/BVSDKDemo
pod install
cd ../..

echo Staring build...
xcodebuild -workspace ./Examples/BVSDKDemo/BVSDKDemo.xcworkspace -scheme "BVSDKDemo" -configuration Debug -sdk iphonesimulator | xcpretty -c

