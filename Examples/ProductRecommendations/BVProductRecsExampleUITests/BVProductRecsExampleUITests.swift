//
//  BVProductRecsExampleUITests.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import XCTest

class BVProductRecsExampleUITests: XCTestCase {
        
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func setupHorizontalCarousel() -> XCUIApplication {
        let app = XCUIApplication()
        
        XCTAssertEqual(app.collectionViews.count, 1)
        let collectionView = app.collectionViews.elementBoundByIndex(0)

        // wait up to 10 seconds for cells to appear
        _ = self.expectationForPredicate(
            NSPredicate(format: "self.count > 0"),
            evaluatedWithObject: collectionView.cells,
            handler: nil)
        
        self.waitForExpectationsWithTimeout(10.0, handler: nil)
        
        // ensure the collection view has cells
        XCTAssertGreaterThan(collectionView.cells.count, 0, "Recommendations carousel had zero cells.")
        
        return app
    }
    
    func testHorizontalCarouselHasCells() {
        setupHorizontalCarousel()
    }
    
    func testTableViewController() {
        
        let app = XCUIApplication()
        XCUIApplication().scrollViews.otherElements.staticTexts["TableViewController"].tap()
        
        XCTAssertEqual(app.tables.count, 1)
        let tableView = app.tables.elementBoundByIndex(0)
        
        // wait up to 10 seconds for cells to appear
        _ = self.expectationForPredicate(
            NSPredicate(format: "self.count > 0"),
            evaluatedWithObject: tableView.cells,
            handler: nil)
        
        self.waitForExpectationsWithTimeout(10.0, handler: nil)
        
        // ensure the collection view has cells
        XCTAssertGreaterThan(tableView.cells.count, 0, "Recommendations table view had zero cells.")
        
    }
    
    func testStackViewController() {
        
        let app = XCUIApplication()
        XCUIApplication().scrollViews.otherElements.staticTexts["StaticView"].tap()
        
        
        
        XCTAssertNotNil(app.otherElements["BVRecommendationsStaticView"])
        XCTAssertNotNil(app.otherElements["JasonJason"])
//        let tableView = app.tables.elementBoundByIndex(0)
//        
//        // wait up to 10 seconds for cells to appear
//        _ = self.expectationForPredicate(
//            NSPredicate(format: "self.count > 0"),
//            evaluatedWithObject: tableView.cells,
//            handler: nil)
//        
//        self.waitForExpectationsWithTimeout(10.0, handler: nil)
//        
//        // ensure the collection view has cells
//        XCTAssertGreaterThan(tableView.cells.count, 0, "Recommendations table view had zero cells.")
        
    }
    
}
