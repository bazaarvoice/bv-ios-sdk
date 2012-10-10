# Bazaarvoice iOS SDK 
### *Version 1.3.2* (Public Beta)	

## Introduction
The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 4 or newer.

Developers can display content as well as submit content such as Ratings & Reviews, Ask & Answer and Stories, including text and photo. Included reference apps and a Quick Start Guide will allow developers to integrate Bazaarvoice quickly, with little overhead.

**Where to start:**
 1. Read the Quick Start guide to get familiar with installation and building a bare-bones, simple application that uses the SDK.
 2. The documentation, located in the docs folder, provides additional information into the capabilities of the SDK itself.
 3. Sample applications, located in the apps folder, provide example uses of the SDK and implementation best practices.

## Requirements
* Bazaarvoice Platform API version 5.3 or older
 * Signed Data Usage Amendment, if not already in place
 * API configured and enabled by Bazaarvoice
 * API key to access client's staging and production data
 * Go to the [Bazaarvoice Developer Portal](http://developer.bazaarvoice.com) to get the above completed
* Xcode IDE version 4.3 or newer
* Note: This SDK is designed specifically for iOS 5, but also works for iOS 4

## What's Included
This package includes the following:

* iOS SDK based on Bazaarvoice Developer API
* Quick Start Guide - Quickly get familiar with installation and building a bare-bones, simple application that uses the SDK
* Reference applications
 * Product browse example: Illustrates using the Bazaarvoice iOS SDK to query, browse and display ratings and reviews for products
 * Photo upload example: Illustrates using the Bazaarvoice iOS SDK to submit a photo-review that include a user generated photo (camera/gallery), star rating and review text.
 * “Kitchen Sink” app: Covers all the baseline method calls and their responses. It’s a good way for developers see the all the requests and responses of the SDK out of the box.
 * iOS 4 example: Reference example designed specifically for iOS 4


## Troubleshooting

1. **Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFString JSONValue]: unrecognized selector sent to instance 0x...**

	Make sure that you have added the -ObjC flag under Other Linker Flags in Build Settings.  

	This compiler flag instructs the linker to include all objects from the bv static library.

2. **Duplicate symbol _objc_retainedObject in /<project_path>/libarclite_universal.a(arclite.o) and /<toolchain path>/usr/lib/arc/libarclite_iphonesimulator.a(arclite.o) for architecture i386**

	Navigate to your Project Settings -> Targets -> Build Phases.  Under "Link Binary With Libraries" remove libarclite_universal.a from the list of linked libraries.

	This error occurs when XCode automatically links against libarclite, usually when compiling an arc project for deployment with a pre-arc iOS version. Removing the provided libarclite eliminates the linker conflict.