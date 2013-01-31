Bazarvoice iOS SDK Source Code Development 
=

(internal use only)


The following document includes steps on how to rebuild the static library (the SDK) after one has made changes to the codebase.  It also includes steps on how to run the unit tests.

System Requirements
-

**You must have Xcode 4.5 (or the latest version)**

### Xcode Requirements

- Install 5.X, 6.X Simultors

**Protip**: Xcode -> Preferences -> Downloads (Tab) -> Install Button
to get the above simulators.

To Build The Static Library
-

1. Navigate into the BVSDK project
2. Double-click the Xcode Project/open in Xcode -- ```BVSDK.xcodeproj```
3. Product -> Clean
4. Product -> Build
5. Wait...
6. Build Succeeded
7. Open the “Products” folder in the Project Pane in Xcode, right-click ```BVSDK.framework``` and select “Show In Finder”
8. Double check that this opens the Release-iphoneos or Release-iphonesimulator folder.  If not, double check that the scheme is "Release." If not, this can be modified under Product->Scheme-Edit Scheme.
9. You should see the BVSDK.framework folder.  This folder contains the merged universal binary (BVSDK) and associated headers (Headers).  This is the SDK.

To Run The Unit Tests
--

1. Navigate into the BVSDK
2. Double-click Xcode Project -- ```BVSDK.xcodeproj```
3. Verify you have a simulator available _and_ it is selected.  If there is not a simulator available, download the latest version of Xcode (see Xcode Requirements above).
4. Turn on the console by clicking on the middle button in the View toolbar in the upper right corner if the console is not already visible.
5. Now, click Product -> Test (or Command + U)
6. Wait...
7. Build succeeded
8. Unit tests should now be running.
9. Evaluate successful and failed tests.


To Generate Docs
--

1. Download and install appledoc.  The simplest way is via github:
	- git clone git://github.com/tomaz/appledoc.git
	- cd appledoc
	- sudo sh install-appledoc.sh 
		- NOTE: In some cases, you may have to configure the XCode path before installing appledoc with xcode-switch.  For instance, if XCode is installed in the /Applications directory, run:
		- sudo ./xcode-select -switch /Applications/Xcode.app 
		- Detailed instructions can be found here: https://github.com/tomaz/appledoc
2. Within the bv-ios-sdk-dev directory run ./generate_docs.  Appledoc will parse comments from the project header files and output documentation to the docs directory.

To Create A Point Release
--
- Update the SDK\_HEADER\_VALUE in BVNetwork.h 
- Update the version number under the project Build Settings -> Packaging -> Framework Version
- Clean and build the SDK. Delete the old BVSDK.framework directory from bv-ios-sdk and copy the new BVSDK.framework directory into bv-ios-sdk.
- Update the reference apps to use the new release.
- Update CHANGELOG.md to reflect the changes and update README.md to the appropriate version number.
- Perform the standard github commit flow (add files, commit, push...)
- Tag the commit:
	- git tag -a v2.X.Y -m "SDK Version 2.X.Y for API Version 5.X"
- Push the tags
	- git push --tags
	
Tips
--
The project is based on the iOS Universal Framework project.  See:

https://github.com/kstenerud/iOS-Universal-Framework/

Common build-config issues:

1. Make sure that the build is set to "Release": Product->Scheme->Edit Scheme
2. Make sure that we're building for armv7 and armv7s (In Build Settings, Build Active Architecture Only should be set to "No")
3. Compiler optimizations can cause problems (not sure why... but for now I used compiler optimizations:none)
4. The build script uses symbolic links to maintain versions.  The version can be changed under the project Build Settings -> Packaging -> Framework version.  The critical lines of the build script are under: # Build framework structure "Build symlinks" if something goes wrong here.
https://github.com/kstenerud/iOS-Universal-Framework/issues/101

Checking available architectures is a common problem.  To check the architectures or a compiled binary, use xcodes's included lipo command:
xcrun -sdk iphoneos lipo -info <binary>