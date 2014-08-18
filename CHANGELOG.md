## 2.2.0 (Aug 17, 2014) 

* Updated BVSDK to v2.2.0 which supports iOS 8 and fixes 64-bit problems.

## 2.1.6 (Sep. 26, 2013)
 
* Includes updates for iOS 7 and 64-bit slices

## 2.1.5 (Sep. 4, 2013)

* Fixes issue with making requests off of the main thread.

## 2.1.4 (Aug. 8, 2013)

* Adds ability to upload video from disk.
* Improved memory management.

## 2.1.3 (Jul. 19, 2013)

* Adds source code.

## 2.1.2 (Feb. 12, 2013)

* Contains debug build for client linking.

## 2.1.1 (Feb. 12, 2013)

* Fixes deployment target issue.  Updates to API 5.4

## 2.1.0 (Jan. 30, 2012)

* Adds omitted BVFeedbackContentType.  Updates directory structure to utilize BVSDK as a framework.

## 2.0.0 (Dec. 21, 2012)

* First officially supported release, for API Version 5.3

## 1.3.3 (Oct. 10, 2012)

* Simplified error handling

## 1.3.2 (Oct. 10, 2012)

* Updated for iPhone 5.  Drops support for armv6.

## 1.3.1 (Oct. 1, 2012)

* Provides support for Search_Type parameters

## 1.3.0 (Sep. 18, 2012)

* Updates API version to 5.3

## 1.2.6 (Sep. 11, 2012)

* Removes ".bazaarvoice.com" from being appended to the BVSettings customerName.  This allows cnamed domains such as reviews.customer.com to be used as the base url.  
Note: this will break existing implementations.  For instance, if the customerName was previously set to ugc.client, it should now be set to ugc.client.bazaarvoice.com.

## 1.2.5 (Aug. 24, 2012)

* Fixes bug which was attaching unnecessary parameters in some cases.

## 1.2.4 (Jul. 26, 2012)

* Includes build for armv6 architectures.

## 1.2.3 (Jul. 25, 2012)

* Adds support for feedback submission.  See http://developer.bazaarvoice.com/api/5/2/feedback-submission.
* Allows for multiple key/value pairs on a single BVParameterType.  For instance, tag\_1=something and tag\_2=something may be set on a single request.
* Adds support for parameters.tagid

## 1.2.2 (Jul. 19, 2012)

* Fixes a collision in SBJSON library for clients including libraries which also utilize SBJSON.

## 1.2.1 (Jul. 09, 2012)

* Fixes a critical bug in review submission with photo attachment.

## 1.2.0 (Jul. 02, 2012)

* First officially supported release, for API Version 5.2
