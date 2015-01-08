#!/bin/bash
echo "This script will:"
echo "    1) Verify that SDK version (in BVNetwork.h) equals Cocoapods version (in BVSDK.podspec)"
echo "    2) Generate apple docs"
echo "    3) Update CHANGELOG.md with commit message"
echo "    4) Update README.md with the new SDK version number"
echo ""

cd ..

SDK_VER=$(grep "SDK_HEADER_VALUE @" Pod/Classes/BVNetwork.h)
FRAMEWORK_VER=$(grep "s.version = " BVSDK.podspec)

SDK_VER="v${SDK_VER:36:3}"
FRAMEWORK_VER="v${FRAMEWORK_VER:15:1}${FRAMEWORK_VER:17:1}${FRAMEWORK_VER:19:1}"

echo "Version appears to be $SDK_VER, is that correct (y/n)? (if not, check BVNetwork.h)"
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
./generate_docs

echo "Enter a commit message"
read commitmsg

NOW=$(date +"%b %d, %Y")
CHANGELOG_STR="## $SDK_VER_NOV ($NOW) \n\n $commitmsg \n\n"
echo -e "$CHANGELOG_STR$(cat CHANGELOG.md)" > CHANGELOG.md

git commit -am "$commitmsg"
git tag -a "$SDK_VER" -m "SDK $SDK_VER for API Version 5.4"

echo "Done. Run `git push` and `git push --tags`. Then, deploy to cocoapods following instructions here: http://guides.cocoapods.org/making/using-pod-lib-create.html"

