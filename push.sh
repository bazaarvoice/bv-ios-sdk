#!/bin/bash
SDK_PATH=/Users/alex.medearis/Desktop/bv-ios-sdk
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
	echo "Framework version does not equal SDK version.  Verify that you've set the framework version in the project properties (project.pbxjproj)"
    exit 1;
fi

cd ..
echo "Cleaning up..."
rm -rf "$SDK_PATH/docs"
echo "Generating docs..."
./generate_docs
echo "Copying docs..." 
cp -r ./docs "$SDK_PATH/"

cd BVSDK

echo "Building..."
rm -rf build
/usr/bin/xcodebuild -target BVSDK -configuration Debug clean build

echo "Copying framework to SDK directories..."
rm -rf "$SDK_PATH/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/BrowsePhotoExample/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/KitchenSink/BVSDK.framework"
rm -rf "$SDK_PATH/Reference Apps/PhotoUploadExample/BVSDK.framework"

cp -r ./build/Debug-iphoneos/BVSDK.framework "$SDK_PATH/"
cp -r ./build/Debug-iphoneos/BVSDK.framework "$SDK_PATH/Reference Apps/BrowsePhotoExample/"
cp -r ./build/Debug-iphoneos/BVSDK.framework "$SDK_PATH/Reference Apps/KitchenSink/"
cp -r ./build/Debug-iphoneos/BVSDK.framework "$SDK_PATH/Reference Apps/PhotoUploadExample/"

echo "Enter a commit message"
read commitmsg

cd ..
SDK_VER_NOV="${SDK_VER:1:1}.${SDK_VER:2:1}.${SDK_VER:3:1}"
mkdir "$COCOAPODS_SPECS/Bazaarvoice/$SDK_VER_NOV"
rm -rf "$COCOAPODS_SPECS/Bazaarvoice/$SDK_VER_NOV/*"
cp Bazaarvoice.podspec.template Bazaarvoice.podspec
sed -i '' "s/VERSIONNUM/$SDK_VER_NOV/g" ./Bazaarvoice.podspec
mv ./Bazaarvoice.podspec "$COCOAPODS_SPECS/Bazaarvoice/$SDK_VER_NOV/"
cd "$COCOAPODS_SPECS"
#git commit -am "$commitmsg" 
#git push

cd "$SDK_PATH"
NOW=$(date +"%b %d, %Y")
CHANGELOG_STR="## $SDK_VER_NOV ($NOW) \n\n $commitmsg \n\n"
echo -e "$CHANGELOG_STR$(cat CHANGELOG.md)" > CHANGELOG.md
README_STR="### *Version $SDK_VER_NOV*"
sed -i '' "2s/.*/$README_STR/" ./README.md

#git commit -am "$commitmsg" 
#git push
#git tag -a "$SDK_VER" -m "SDK $SDK_VER for API Version 5.4"
#git push --tags

