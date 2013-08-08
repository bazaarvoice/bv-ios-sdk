#!/bin/bash
SDK_PATH=..
COCOAPODS_SPECS=/Users/alex.medearis/Desktop/Specs

cd BVSDK
SDK_VER=$(grep "SDK_HEADER_VALUE @" BVSDK/BVNetwork.h)
FRAMEWORK_VER=$(grep "FRAMEWORK_VERSION =" BVSDK.xcodeproj/project.pbxproj)

SDK_VER="v${SDK_VER:36:3}"
FRAMEWORK_VER="v${FRAMEWORK_VER:24:1}${FRAMEWORK_VER:26:1}${FRAMEWORK_VER:28:1}"

echo "Version appears to be $SDK_VER, is that correct (y/n)? (if not, check BVNetwork.h)"
read confirm
if [ $confirm != 'y' ]; then
        exit 1;
fi

if [ $SDK_VER != $FRAMEWORK_VER ]; then
	echo "Framework version does not equal SDK version.  Verify that you've set the framework version in the project properties (project.pbxjproj or Target -> Build Settings -> Packaging -> Framework Version)"
    exit 1;
fi

cd ..
echo "Generating docs..."
./generate_docs.sh

cd BVSDK

echo "Building..."
rm -rf build
/usr/bin/xcodebuild -target BVSDK -configuration Debug clean build

cd ..
cp -r BVSDK/build/Debug-iphoneos/BVSDK.framework .

echo "Copying framework to SDK directories..."
rm -rf "$SDK_PATH/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/BrowsePhotoExample/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/KitchenSink/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/PhotoUploadExample/BVSDK.framework"

cp -r ./BVSDK.framework "$SDK_PATH/"
cp -r ./BVSDK.framework "$SDK_PATH/Reference Apps/BrowsePhotoExample/"
cp -r ./BVSDK.framework "$SDK_PATH/Reference Apps/KitchenSink/"
cp -r ./BVSDK.framework "$SDK_PATH/Reference Apps/PhotoUploadExample/"

rm -rf ./BVSDK.framework
