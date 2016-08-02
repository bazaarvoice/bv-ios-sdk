//
//  PhotoSizesParsingTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class PhotoSizesParsingTests: XCTestCase {
    
    func testParsePhotoSizes() {

        let sizes = BVPhotoSizes(apiResponse: convertStringToDictionary("{\"thumbnail\":{\"Url\": \"http://apireadonly.ugc.bazaarvoice.com/bvstaging/5556/80500/photoThumb.jpg\",\"Id\": \"thumbnail\"},\"normal\": {\"Url\": \"http://apireadonly.ugc.bazaarvoice.com/bvstaging/5556/80500/photo.jpg\",\"Id\": \"normal\"}}"))
        
        XCTAssertEqual(sizes?.thumbnailUrl, "http://apireadonly.ugc.bazaarvoice.com/bvstaging/5556/80500/photoThumb.jpg")
        XCTAssertEqual(sizes?.normalUrl, "http://apireadonly.ugc.bazaarvoice.com/bvstaging/5556/80500/photo.jpg")
    }
    
    func testPrasePhotoSizesFail() {
        let sizes = BVPhotoSizes(apiResponse: convertStringToDictionary("123InvalidJSON"))
        
        XCTAssertNil(sizes);
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}
