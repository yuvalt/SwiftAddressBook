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
class SwiftAddressBookTests: XCTestCase {
    
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
    
    func testGetAllPeople() {

		let testExpectation = expectationWithDescription("testGetAllPeople")

        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            XCTAssertTrue(success, self.accessError)
            if success {
                let people : Array<SwiftAddressBookPerson>? = swiftAddressBook?.allPeople
                
                XCTAssert(people?.count > 0, "Unable to get people from address book")
            } else {
                XCTAssertNotNil(error, self.accessErrorNil)
			}
			
			testExpectation.fulfill()
		})

		waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testSearchPeople() {

		let testExpectation = expectationWithDescription("testSearchPeople")

        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            XCTAssertTrue(success, self.accessError)
            if success {
                let people = swiftAddressBook?.peopleWithName("Kate")
                XCTAssert(people?.count == 1, "Failed to find people")
            } else {
                XCTAssertNotNil(error, self.accessErrorNil)
			}
			
			testExpectation.fulfill()
		})

		waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testAddGetPerson() {

		let testExpectation = expectationWithDescription("testAddGetPerson")

        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            XCTAssertTrue(success, self.accessError)
            if success {
                let optionalPerson = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Kate" }).first
                XCTAssertNotNil(optionalPerson, "Failed to get person 1 \"Kate Bell\" from sample address book")
                if let person = optionalPerson {
                    XCTAssert(person.firstName == "Kate", "First name was wrong")
                    XCTAssert(person.lastName == "Bell", "Last name was wrong")
                    XCTAssert(person.jobTitle == "Producer", "Job Title was wrong")
                    XCTAssert(person.organization == "Creative Consulting", "Organization was wrong")
                    XCTAssert(person.phoneNumbers != nil, "Phone numbers collection was nil")
                    if let phoneNumbers = person.phoneNumbers {
                        XCTAssert(phoneNumbers.count == 2, "Wrong phone number count")
                        XCTAssert(phoneNumbers[0].label == kABPersonPhoneMobileLabel, "Incorrect first phone label")
                        XCTAssert(phoneNumbers[0].value == "(555) 564-8583", "Incorrect first phone number")
                        XCTAssert(phoneNumbers[1].label == kABPersonPhoneMainLabel, "Incorrect second phone label")
                        XCTAssert(phoneNumbers[1].value == "(415) 555-3695", "Incorrect second phone number")
                    }
                    XCTAssert(person.phoneNumbers != nil, "Email collection was nil")
                    if let emails = person.emails {
                        XCTAssert(emails.count == 2, "Wrong email count")
                        XCTAssert(emails[0].label == kABWorkLabel, "Incorrect first email label")
                        XCTAssert(emails[0].value == "kate-bell@mac.com", "Incorrect first email")
                        XCTAssert(emails[1].label == kABWorkLabel, "Incorrect second email label")
                        XCTAssert(emails[1].value == "www.icloud.com", "Incorrect second email")
                    }
                    XCTAssert(person.addresses != nil, "Address collection was nil")
                    if let addresses = person.addresses {
                        XCTAssert(addresses.count == 1, "Wrong address count")
                        XCTAssert(addresses[0].label == "work", "Incorrect address label")
                        var address = addresses[0].value
                        XCTAssert(address.count == 4, "Incorrect address value count")
                        XCTAssert(address[SwiftAddressBookAddressProperty.street] as? NSString == "165 Davis Street", "Incorrect street")
                        XCTAssert(address[SwiftAddressBookAddressProperty.city] as? NSString == "Hillsborough", "Incorrect city")
                        XCTAssert(address[SwiftAddressBookAddressProperty.state] as? NSString == "CA", "Incorrect state")
                        XCTAssert(address[SwiftAddressBookAddressProperty.zip] as? NSString == "94010", "Incorrect zip")
                    }
					let date = self.getDate(1978, 01, 20).dateByAddingTimeInterval(13*60*60)
                    XCTAssert(person.birthday! == date, "Incorrect birthday (was \(person.birthday))")
                }
            } else {
                XCTAssertNotNil(error, self.accessErrorNil)
			}
			
			testExpectation.fulfill()
		})

		waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testAddRemovePerson() {

		let testExpectation = expectationWithDescription("testAddRemovePerson")

        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            XCTAssertTrue(success, self.accessError)
            if success {
                var optionalPerson: SwiftAddressBookPerson? = SwiftAddressBookPerson.create()
                var timeStamp = self.getDateTimestamp()
                if let person = optionalPerson {
                    
                    //TODO: test ALL fields
                    person.firstName = "Darth" + timeStamp
                    person.lastName = "Vader" + timeStamp
                    person.nickname = "Anakin" + timeStamp
                    person.note = "Super-high midi-chlorian count" + timeStamp
                    var email = MultivalueEntry(value: "darthvader@mailinator.com", label: "home", id: 0)
                    person.emails = [email]
                    var phone = MultivalueEntry(value: "(555) 555-1234", label: "office", id: 0)
                    person.phoneNumbers = [phone]
                    var addressData = [
                        SwiftAddressBookAddressProperty.street: "123 Main Bridge" as AnyObject, //TODO: Can we make it so they don't have to cast here, please?
                        SwiftAddressBookAddressProperty.city: "Upper Sphere" as AnyObject,
                        SwiftAddressBookAddressProperty.state: "Death Star" as AnyObject,
                        SwiftAddressBookAddressProperty.zip: "12345" as AnyObject
                    ]
                    var address = MultivalueEntry(value: addressData, label: "work", id: 0)
                    person.addresses = [address]
                    swiftAddressBook?.addRecord(person)
                    swiftAddressBook?.save()
                }
                
                optionalPerson = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Darth" + timeStamp }).first
                XCTAssertNotNil(optionalPerson, "Couldn't find newly added person")
                
                if let person = optionalPerson {
                    XCTAssert(person.firstName == "Darth" + timeStamp, "Failed to save first name")
                    XCTAssert(person.lastName == "Vader" + timeStamp, "Failed to save last name")
                    XCTAssert(person.nickname == "Anakin" + timeStamp, "Failed to save nickname")
                    
                    swiftAddressBook?.removeRecord(person)
                    swiftAddressBook?.save()
                }
            } else {
                XCTAssertNotNil(error, self.accessErrorNil)
            }

			testExpectation.fulfill()
        })

		waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
    func testAddEditRemovePerson() {

		let testExpectation = expectationWithDescription("testAddEditRemovePerson")

        swiftAddressBook?.requestAccessWithCompletion({ (success, error) -> Void in
            XCTAssertTrue(success, self.accessError)
            if success {
                var optionalPerson: SwiftAddressBookPerson? = SwiftAddressBookPerson.create()
                var timeStamp = self.getDateTimestamp()
                if let person = optionalPerson {
                    person.firstName = "Test" + timeStamp;
                    swiftAddressBook?.addRecord(person)
                    swiftAddressBook?.save()
                }
                
                optionalPerson = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Test" + timeStamp }).first
                XCTAssertNotNil(optionalPerson, "Couldn't find newly added person")
                
                if optionalPerson != nil {
                    if let person = optionalPerson {
                        //TODO: test ALL fields
                        person.firstName = "Darth" + timeStamp
                        person.lastName = "Vader" + timeStamp
                        person.nickname = "Anakin" + timeStamp
                        person.note = "Super-high midi-chlorian count" + timeStamp
                        var email = MultivalueEntry(value: "darthvader@mailinator.com", label: "home", id: 0)
                        person.emails = [email]
                        var phone = MultivalueEntry(value: "(555) 555-1234", label: "office", id: 0)
                        person.phoneNumbers = [phone]
                        var addressData = [
                            SwiftAddressBookAddressProperty.street: "123 Main Bridge" as AnyObject, //TODO: Can we make it so they don't have to cast here, please?
                            SwiftAddressBookAddressProperty.city: "Upper Sphere" as AnyObject,
                            SwiftAddressBookAddressProperty.state: "Death Star" as AnyObject,
                            SwiftAddressBookAddressProperty.zip: "12345" as AnyObject
                        ]
                        var address = MultivalueEntry(value: addressData, label: "work", id: 0)
                        person.addresses = [address]
                        
                        swiftAddressBook?.save()
                    }
                    
                    optionalPerson = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Darth" + timeStamp }).first
                    XCTAssertNotNil(optionalPerson, "Couldn't find newly edited person")
                    
                    if let person = optionalPerson {
                        
                        XCTAssert(person.firstName == "Darth" + timeStamp, "Incorrect first name")
                        XCTAssert(person.lastName == "Vader" + timeStamp, "Incorrect last name")
                        XCTAssert(person.nickname == "Anakin" + timeStamp, "Incorrect nickname")
                        XCTAssert(person.note == "Super-high midi-chlorian count" + timeStamp, "Incorrect note")
                        XCTAssert(person.emails?.count == 1, "Incorrect email count")
                        XCTAssert(person.phoneNumbers?.count == 1, "Incorrect phone number count")
                        XCTAssert(person.addresses?.count == 1, "Incorrect addresses count")
                        
                        
                        swiftAddressBook?.removeRecord(person)
                        swiftAddressBook?.save()
                    } else if let person = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Test" + timeStamp }).first { //Clean up failed test
                        swiftAddressBook?.removeRecord(person)
                        swiftAddressBook?.save()
                    }
                }
            } else {
                XCTAssertNotNil(error, self.accessErrorNil)
			}
			
			testExpectation.fulfill()
		})

		waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    
    //MARK: - Helper funtions
    
    func getDateTimestamp() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return formatter.stringFromDate(NSDate())
    }
    
    func getDate(year: Int,_ month: Int,_ day: Int) -> NSDate {
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
}
