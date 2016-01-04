//
//  SwiftAddressBookTests.swift
//  SwiftAddressBookTests
//
//  Created by Albert Bori on 2/23/15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import XCTest
import SwiftAddressBook
import AddressBook

//**** Run the example project first, to accept address book access ****
class SwiftAddressBookSourceTests: XCTestCase {
    
    let accessError = "Address book access was not granted. Run the main application and grant access to the address book."
    let accessErrorNil = "Failed to get address book access denial error"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	//TODO: test source with id method
    
	func testGetDefaultSourceAndProperties() {

		if (swiftAddressBook == nil) {
			XCTAssertNotNil(swiftAddressBook, self.accessErrorNil)
			return
		}

		let source = swiftAddressBook!.defaultSource
		if let defaultSource = source {

			let type = defaultSource.sourceType
			let searchable = defaultSource.searchable
			let sourceName = defaultSource.sourceName

			XCTAssert(type == SwiftAddressBookSourceType.local, "default source must be of type local")
			XCTAssert(sourceName == nil, "default source has no name, but should not")
			XCTAssert(searchable == false, "default source is wrongly marked searchable")
		}
		else {
			XCTAssert(false, "There must always be a default source!")
		}
	}

	func inspectAllSources() {

		if (swiftAddressBook == nil) {
			XCTAssertNotNil(swiftAddressBook, self.accessErrorNil)
			return
		}

		let sources = swiftAddressBook!.allSources

		if let unwrappedSources = sources {
			if unwrappedSources.count == 0 {
				XCTAssert(false, "There must always be at least a default source!")
			}
		}
		else {
			XCTAssert(false, "something went wrong getting array of all sources")
		}
	}
}
