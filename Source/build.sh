#!/bin/bash
SDK_PATH=..

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

echo "Done!"