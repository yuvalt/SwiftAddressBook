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
class SwiftAddressBookPersonTests: XCTestCase {

	let waitTime = 3.0
    
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

	//TODO: test person related methods from swiftaddressbook

	func testGetPerson() {

		let testExpectation = expectationWithDescription("testGetPerson")

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

					if let image = person.image {
						XCTAssert(false, "this person has no image, but returns one!");
					}

					if let phoneNumbers = person.phoneNumbers {
						XCTAssert(phoneNumbers.count == 2, "Wrong phone number count")
						XCTAssert(phoneNumbers[0].label == String(kABPersonPhoneMobileLabel), "Incorrect first phone label")
						XCTAssert(phoneNumbers[0].value == "(555) 564-8583", "Incorrect first phone number")
						XCTAssert(phoneNumbers[1].label == String(kABPersonPhoneMainLabel), "Incorrect second phone label")
						XCTAssert(phoneNumbers[1].value == "(415) 555-3695", "Incorrect second phone number")
					}
					XCTAssert(person.phoneNumbers != nil, "Email collection was nil")
					if let emails = person.emails {
						XCTAssert(emails.count == 2, "Wrong email count")
						XCTAssert(emails[0].label == String(kABWorkLabel), "Incorrect first email label")
						XCTAssert(emails[0].value == "kate-bell@mac.com", "Incorrect first email")
						XCTAssert(emails[1].label == String(kABWorkLabel), "Incorrect second email label")
						XCTAssert(emails[1].value == "www.icloud.com", "Incorrect second email")
					}
					XCTAssert(person.addresses != nil, "Address collection was nil")
					if let addresses = person.addresses {
						XCTAssert(addresses.count == 1, "Wrong address count")
						XCTAssert(addresses[0].label == String(kABWorkLabel), "Incorrect address label")
						var address = addresses[0].value
						//address dictionary contains countryCode, state, street, zip and city in this case
						XCTAssert(address.count == 5, "Incorrect address value count")
						XCTAssert(address[SwiftAddressBookAddressProperty.street] as? NSString == "165 Davis Street", "Incorrect street")
						XCTAssert(address[SwiftAddressBookAddressProperty.city] as? NSString == "Hillsborough", "Incorrect city")
						XCTAssert(address[SwiftAddressBookAddressProperty.state] as? NSString == "CA", "Incorrect state")
						XCTAssert(address[SwiftAddressBookAddressProperty.zip] as? NSString == "94010", "Incorrect zip")
					}
					let date = self.getDate(1978, 01, 20, 12)
					XCTAssert(person.birthday! == date, "Incorrect birthday (was \(person.birthday))")
				}
			} else {
				XCTAssertNotNil(error, self.accessErrorNil)
			}
			
			testExpectation.fulfill()
		})

		waitForExpectationsWithTimeout(waitTime, handler: nil)
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

		waitForExpectationsWithTimeout(waitTime, handler: nil)
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
                    XCTAssertNotNil(optionalPerson, "Newly added person was not saved")

					let people = swiftAddressBook?.peopleWithName("Darth")
					XCTAssert(people?.count > 0 && people![0].firstName == "Darth" + timeStamp, "Failed to find person by searching for name")
                    
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

		waitForExpectationsWithTimeout(waitTime, handler: nil)
    }

    
	func testNilPropertiesAndOverridingMultivalues() {

		let testExpectation = expectationWithDescription("testNilPropertiesAndOverridingMultivalues")

		swiftAddressBook?.requestAccessWithCompletion { (success, error) -> Void in
			XCTAssertTrue(success, self.accessError)
			if success {
				let person = SwiftAddressBookPerson.create()
				swiftAddressBook!.addRecord(person);
				
				//multivalue entry with nil label
				person.addresses = [MultivalueEntry(value: [SwiftAddressBookAddressProperty.street : "testStreet"],
					label: nil,
					id: 0),
					MultivalueEntry(value: [SwiftAddressBookAddressProperty.street : "testStreet"],
						label: "testLabel",
						id: 0)]
				//nil multivalue dictionary property
				person.socialProfiles = nil
				//nil multivalue property
				person.phoneNumbers = nil
				//nil single value property
				person.firstName = nil

				swiftAddressBook!.save()

				XCTAssertNil(person.addresses?.first?.label, "label of first address should be nil")
				XCTAssertNotNil(person.addresses?.last?.label, "label of second address should be not nil")
				XCTAssert(person.socialProfiles == nil, "social profiles should be nil")
				XCTAssert(person.phoneNumbers == nil, "phone numbers should be nil")
				XCTAssert(person.firstName == nil, "first name should be nil")

				if let label = person.addresses?.first?.label {
					XCTAssert(false, "label of first address must not be unwrapped")
				}

				if let label2 = person.addresses?.last?.label {
					XCTAssertEqual(label2, "testLabel", "label of second address must be testLabel")
				}
				else {
					XCTAssert(false, "should be able to unwrap label of second address")
				}

				if let socialProfiles = person.socialProfiles {
					XCTAssert(false, "social profiles must not be unwrapped")
				}

				if let phoneNumbers = person.phoneNumbers {
					XCTAssert(false, "phone numbers must not be unwrapped")
				}

				if let label = person.firstName {
					XCTAssert(false, "first name must not be unwrapped")
				}

				//try overriding label of both addresses
				var addresses = person.addresses!
				addresses[0] = MultivalueEntry(value: addresses[0].value, label: "testLabel", id: addresses[0].id)
				addresses[1] = MultivalueEntry(value: addresses[1].value, label: nil, id: addresses[1].id)

				person.addresses = addresses
				swiftAddressBook!.save()

				XCTAssert(person.addresses?.count == 2, "person should have exactly 2 addresses")

				if let label = person.addresses?.last?.label {
					XCTAssert(false, "label of second address cannot be unwrapped")
				}

				if let label2 = person.addresses?.first?.label {
					XCTAssertEqual(label2, "testLabel", "label of first address must be testLabel")
				}
				else {
					XCTAssert(false, "should be able to unwrap label of first address")
				}

				swiftAddressBook!.removeRecord(person)
				swiftAddressBook!.save()

			}
			else {
				XCTAssertNotNil(error, self.accessErrorNil)
			}

			testExpectation.fulfill()
		}


		waitForExpectationsWithTimeout(waitTime, handler: nil)
	}

	



	//MARK: - Helper funtions

	func getDateTimestamp() -> String {
		var formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
		return formatter.stringFromDate(NSDate())
	}

	func getDate(year: Int,_ month: Int,_ day: Int,_ hour: Int) -> NSDate {
		var components = NSDateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.timeZone = NSTimeZone(name: "UTC")
		return NSCalendar.currentCalendar().dateFromComponents(components)!
	}
}
