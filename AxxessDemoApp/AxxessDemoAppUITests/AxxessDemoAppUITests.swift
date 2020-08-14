//
//  AxxessDemoAppUITests.swift
//  AxxessDemoAppUITests
//
//  Created by Rahul Dange on 12/08/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import XCTest

class AxxessDemoAppUITests: XCTestCase {

	private var app: XCUIApplication!
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
		app = XCUIApplication()
		app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// -- test if PostTableView is loading or not
    func testHomeScreenPostTableView() {
        // UI tests must launch the application that they test.
		let postTableView = app.tables["PostsTableView"]
		XCTAssertTrue(postTableView.exists, "TableView failed to load.")
	}

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
			        }
    }
}
