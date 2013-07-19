Bazarvoice iOS SDK Source Code Development 
=

The following document includes steps on how to rebuild the static library (the SDK) after one has made changes to the codebase.  It also includes steps on how to run the unit tests.  For third party developers who wish to make a contribution to the iOS SDK, we recommend that you fork the bv-ios-sdk repository, commit locally and then issue a pull request via github.

System Requirements
-

**You must have Xcode 4.5 (or the latest version)**

### Xcode Requirements

- Install 5.X, 6.X Simultors

**Protip**: Xcode -> Preferences -> Downloads (Tab) -> Install Button
to get the above simulators.

To Build The Static Library
--
Within the Source directory run the ```./build.sh``` command from the command line.  This will compile the ```BVSDK.framework``` library.  It will then automatically copy the library into the appropriate places at the top level of the project and reference apps. 

To Modify The Static Library
--

1. The SDK XCode project is located in the BVSDK directory -- ```BVSDK.xcodeproj```.  Double click to open.
2. Make Edits
3. We recommend that you verify your changes by running the unit tests (see below).  
4. Product -> Clean
5. Product -> Build
6. Wait...
7. Build Succeeded
8. Open the “Products” folder in the Project Pane in Xcode, right-click ```BVSDK.framework``` and select “Show In Finder”
9. Double check that this opens the Release-iphoneos or Release-iphonesimulator folder.  If not, double check that the scheme is "Release." If not, this can be modified under Product->Scheme-Edit Scheme.
10. You should see the BVSDK.framework folder.  This folder contains the merged universal binary (BVSDK) and associated headers (Headers).  This is the SDK.

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
2. Within the Source directory run ```./generate_docs.sh```.  Appledoc will parse comments from the project header files and output documentation to the docs directory.

To Create A Point Release
--
- Be sure to update the SDK\_HEADER\_VALUE in BVNetwork.h 
- Update the version number under the project Build Settings -> Packaging -> Framework Version
- Build the SDK using the build.sh script.
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

1. Make sure that we're building for armv7 and armv7s (In Build Settings, Build Active Architecture Only should be set to "No")
2. Compiler optimizations can cause problems (not sure why... but for now I used compiler optimizations:none)
3. The build script uses symbolic links to maintain versions.  The version can be changed under the project Build Settings -> Packaging -> Framework version.  The critical lines of the build script are under: # Build framework structure "Build symlinks" if something goes wrong here.
https://github.com/kstenerud/iOS-Universal-Framework/issues/101

Checking available architectures is a common problem.  To check the architectures or a compiled binary, use xcodes's included lipo command:
xcrun -sdk iphoneos lipo -info <binary>