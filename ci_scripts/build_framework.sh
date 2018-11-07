echo Starting run_tests script
set -euf -o pipefail

echo Building universal framework
xcodebuild -workspace BVSDK.xcworkspace -scheme BVSDK-Universal -configuration Release clean build | xcpretty -c

echo zipping framework...
ditto -ck --rsrc --sequesterRsrc --keepParent ./Output/BVSDK-Release-iphoneuniversal/BVSDK.framework BVSDK.framework.zip

echo validating zipped up framework
./ci_scripts/validate_zips.sh ./BVSDK.framework.zip
