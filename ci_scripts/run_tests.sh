echo Starting run_tests script
set -euf -o pipefail

echo Installing cocoapods dependencies for BVSDK Test target
pod install

echo Running tests
xcodebuild test -workspace BVSDK.xcworkspace -scheme "BVSDK-Tests" -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' | xcpretty -c

