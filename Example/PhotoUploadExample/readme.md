Bazaarvoice iOS SDK - Photo Review Upload Example
=

For simpler integration, this example now uses cocoapods for dependency management.  See http://cocoapods.org/ for details.

To update dependencies:

	pod install
	
To open project:
	
	open PhotoUploadExample.xcworkspace
	
Note: do not use the .xcproject file.

=

This example illustrates using the Bazaarvoice iOS SDK to submit a photo-review that include a user generated photo (camera/gallery), star rating and review text.
Some highlights:

- Use of the native image picker class and integration with the BV SDK
	- See http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html
	
- Use of the Chute PhotoPickerPlus library
	- See https://github.com/chute/photo-picker-plus for more information.

- Photo uploading is performed in the background while the user rates the product.  Note the delegate handoff between ProductViewController and RateViewController
	- See http://speakerdeck.com/u/mikeyk/p/secrets-to-lightning-fast-mobile-design?slide=82

- Use of the photo upload response URL to form a review submission - RateViewController

**Current Status**

As of 9/26/13, photos can be obtained from the camera via native APIs or from a third party such as Facebook or Instagram.  The photo picker is based on the Chute SDK and PhotoPicker+ library.  See:

https://github.com/chute/photo-picker-plus-ios


