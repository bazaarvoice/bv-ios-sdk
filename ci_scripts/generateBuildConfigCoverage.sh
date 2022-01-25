pod install

unzip build-wrapper-macosx-x86.zip
./build-wrapper-macosx-x86/build-wrapper-macosx-x86 --out-dir build_wrapper_output_directory xcodebuild clean build

#Change absolute paths to relative paths
sed -i '.bak' "s+$(pwd)+.+g" build_wrapper_output_directory/build-wrapper-dump.json
#Change path to clang 
sed -i '.bak' "s+/Applications/Xcode_13.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang+/usr/bin/clang-13+g" build_wrapper_output_directory/build-wrapper-dump.json

mkdir derivedData
./build-wrapper-macosx-x86/build-wrapper-macosx-x86 --out-dir DerivedData/compilation-database \
        xcodebuild -workspace BVSDK.xcworkspace \
                -scheme BVSDK \
                -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11,OS=latest' \
                -derivedDataPath DerivedData \
                clean test  -enableCodeCoverage YES CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO


wget https://raw.githubusercontent.com/SonarSource/sonar-scanning-examples/master/swift-coverage/swift-coverage-example/xccov-to-sonarqube-generic.sh
bash xccov-to-sonarqube-generic.sh DerivedData/Logs/Test/*.xcresult/ > sonarqube-generic-coverage.xml

#Replace & with &amp; (& in "/Sorting & Filtering/") 
sed -i '.bak' 's+&+&amp;+g' sonarqube-generic-coverage.xml
#Change absolute paths to relative paths
sed -i '.bak' "s+$(pwd)+.+g" sonarqube-generic-coverage.xml
