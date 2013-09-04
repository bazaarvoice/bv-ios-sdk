# Bazaarvoice iOS SDK 
### *Version 2.1.5*

## Introduction
The Bazaarvoice software development kit (SDK) for iOS is an iOS static library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 5 or newer.

Developers can display content as well as submit content such as Ratings & Reviews, Ask & Answer and Stories, including text and photo. Included reference apps and a Quick Start Guide will allow developers to integrate Bazaarvoice quickly, with little overhead.

**Where to start:**
 1. Read the Quick Start guide to get familiar with installation and building a bare-bones, simple application that uses the SDK.
 2. The documentation, located in the Docs folder, provides additional information into the capabilities of the SDK itself.
 3. Sample applications, located in the Reference Apps folder, provide example uses of the SDK and implementation best practices.
 4. The SDK Source is provided in the Source folder.

## Requirements
* Bazaarvoice Platform API version 5.4 or older
 * Signed Data Usage Amendment, if not already in place
 * API configured and enabled by Bazaarvoice
 * API key to access client's staging and production data
 * Go to the [Bazaarvoice Developer Portal](http://developer.bazaarvoice.com) to get the above completed
* Xcode IDE version 4.5 or newer
* Built for iOS 5+

## What's Included
This package includes the following:

* BVSDK.framework - iOS SDK based on Bazaarvoice Developer API
* Quick Start Guide - Quickly get familiar with installation and building a bare-bones, simple application that uses the SDK
* Reference applications:
    * Product browse example: Illustrates using the Bazaarvoice iOS SDK to query, browse and display ratings and reviews for products
    * Photo upload example: Illustrates using the Bazaarvoice iOS SDK to submit a photo-review that includes a user generated photo (camera/gallery), star rating and review text.
    * “Kitchen Sink” app: Covers all the baseline method calls and their responses. It’s a good way for developers see the all the requests and responses of the SDK out of the box.
* Source - For clients that require custom modifications or would like to contribute to the Bazaarvoice SDK.  See the README in the Source directory for more details.

## Updating from V1
See the included V2UpdateGuide for information on how to update a project using the old BV iOS SDK to version 2.


## License
Except as otherwise noted, the Bazaarvoice iOS SDK licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html).
