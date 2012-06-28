Bazaarvoice iOS SDK
=

**Version: 1.0**

Read the Quick Start guide to get familiar with installation and building a bare-bones, simple application that uses the SDK.

The documentation, located in the docs folder, provides additional information into the capabilities of the SDK itself.

Sample applications, located in the apps folder, provide example uses of the SDK and implementation best practices.

Troubleshooting:
--

*Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFString JSONValue]: unrecognized selector sent to instance 0x..."*

Make sure that you have added the -ObjC flag under Other Linker Flags in Build Settings.  

This compiler flag instructs the linker to include all objects from the bv static library.

*Duplicate symbol _objc_retainedObject in /<project_path>/libarclite_universal.a(arclite.o) and /<toolchain path>/usr/lib/arc/libarclite_iphonesimulator.a(arclite.o) for architecture i386*

Navigate to your Project Settings -> Targets -> Build Phases.  Under "Link Binary With Libraries" remove libarclite_universal.a from the list of linked libraries.

This error occurs when XCode automatically links against libarclite, usually when compiling an arc project for deployment with a non-arc iOS version, which conflicts with the included libarclite.  