Bazaarvoice iOS SDK - Browse Products Example
=

**Version: 1.0**

This example app illustrates use of the Bazaarvoice iOS SDK to perform a photo upload and to rate an existing product.

Some highlights:

- Use of the native image picker class and integration with the BV SDK
	- See http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html

- Photo uploading is performed in the background while the user rates the product.  Note the delegate handoff between ProductViewController and RateViewController
	- See http://speakerdeck.com/u/mikeyk/p/secrets-to-lightning-fast-mobile-design?slide=82

- Use of the photo upload response URL to form a review submission - RateViewController

**Current Status**

As of 5/9/12, this app includes many implementation best practices, but UI best practices are still in development.


