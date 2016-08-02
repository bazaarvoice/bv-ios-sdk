//
//  ProductIdEscapeTests.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import XCTest
@testable import BVSDK

class ProductIdEscapeTests: XCTestCase {

    func testEscape() {
        
        XCTAssertEqual("product\\,shorts", BVCommaUtil.escape("product,shorts"))
        XCTAssertEqual("product\\:shorts", BVCommaUtil.escape("product:shorts"))
        XCTAssertEqual("\\,\\:%26product\\,\\:%26shorts\\,\\:%26", BVCommaUtil.escape(",:&product,:&shorts,:&"))
        
    }
    
    func testMultipleEscapes() {
        
        let input = ["product,shorts", ",:&product,:&shorts,:&"]
        let output = ["product\\,shorts", "\\,\\:%26product\\,\\:%26shorts\\,\\:%26"]
        XCTAssertEqual(BVCommaUtil.escapeMultiple(input), output)
        
    }
    
}