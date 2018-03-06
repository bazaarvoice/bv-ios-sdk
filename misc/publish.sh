#!/bin/bash
echo "This script will:"
echo "    1) Verify that SDK version (in BVSDKConstants.h) equals Cocoapods version (in BVSDK.podspec)"
echo "    2) Generate apple docs"
echo "    3) Update CHANGELOG.md with commit message"
echo "    4) Update README.md with the new SDK version number"
echo ""

cd ..

SDK_VER=$(grep "SDK_HEADER_VALUE @" BVSDK/BVCommon/BVSDKConstants.h) 
FRAMEWORK_VER=$(grep "s.version = " BVSDK.podspec)           

SDK_VER="${SDK_VER:36:1}.${SDK_VER:37:1}.${SDK_VER:38:1}" # format it from '225' to '2.2.5'
FRAMEWORK_VER="${FRAMEWORK_VER:15:5}"                     # already formatted as 2.2.5

echo "Version appears to be $SDK_VER, is that correct (y/n)? (if not, check BVSDKConstants.h)"
read confirm
if [ $confirm != 'y' ]; then
    exit 1;
fi

if [ $SDK_VER != $FRAMEWORK_VER ]; then
	echo "Framework version does not equal SDK version. Verify that you've set the framework version in the Cocoapods podspec (BVSDK.podspec)"
    exit 1;
fi

echo "Versions are equal!"

echo "Generating docs..."
./misc/generate_docs.sh

echo ""
echo "Done."
echo "Commit and push everything. Remember to add a tag if this is a new version!"
echo "Then, deploy to cocoapods following instructions here: http://guides.cocoapods.org/making/using-pod-lib-create.html"
echo ""
