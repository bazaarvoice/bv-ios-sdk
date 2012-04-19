Bazarvoice iOS SDK Source Code Development 
=

(internal use only)


The following document includes steps on how to rebuild the static library (the SDK) after one has made changes to the codebase.  It also includes steps on how to run the unit tests.

System Requirements
-

**You must have Xcode 4.3.2 (or the latest version)**

### Xcode Requirements

- Install 4.3 Simulator (test without ARC)
- Install 5.0 Simultor
- Install 5.1 Simulator 

**Protip**: Xcode -> Preferences -> Downloads (Tab) -> Install Button
to get the above simulators.

To Build The Static Library
-

1. Navigate into the BViOSSDK
2. Double-click the Xcode Project/open in Xcode -- ```bviossdk.xcodeproj```
3. Product -> Clean
4. Product -> Build
5. Wait...
6. Build Succeeded
7. Open the “Products” folder in the Project Pane in Xcode, right-click ```libBViOSSDK.a``` and select “Show In Finder”
8. Now, inside Finder, click View -> Show Path Bar (if it is hidden)
9. Back up two folders into “Products” and open that folder.
10. Copy and paste “Debug-universal” into a temporary folder.
11. In that temp folder, rename to “BV_Static_Lib_Latest” (this will be the folder that you can drag/drop into an Xcode project to use in an actual app using the SDK).
12. Copy and paste ```libarclite_universal.a``` which currently lives in the root of this repository into that folder.
13. Now you have the complete SDK.


To Run The Unit Tests
--

1. Navigate into the BViOSSDK
2. Double-click Xcode Project -- ```bviossdk.xcodeproj```
3. Verify you have a simulator available _and_ it is selected.  If there is not a simulator available, download the latest version of Xcode (see Xcode Requirements above).
4. Turn on the console by clicking on the middle button in the View toolbar in the upper right corner if the console is not already visible.
5. Now, click Product -> Test
6. Wait...
7. Build succeeded
8. Unit tests should now be running.
9. Evaluate successful and failed tests.