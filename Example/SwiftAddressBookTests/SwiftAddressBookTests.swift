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

//**** Run the example project first, to accept address book access ****
class SwiftAddressBookTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAllPeople() {
        let people : Array<SwiftAddressBookPerson>? = swiftAddressBook?.allPeople
        
        XCTAssert(people?.count > 0, "Unable to get people from address book")
    }
    
    func testSearchPeople() {
        let people = swiftAddressBook?.peopleWithName("Kate")
        XCTAssert(people?.count == 1, "Failed to find people")
    }
    
    func testAddGetPerson() {
        let person = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Kate" }).first
        XCTAssertNotNil(person, "Failed to get person 1 \"Kate Bell\" from sample address book")
        if let person = person {
            XCTAssert(person.firstName == "Kate", "First name was wrong")
            XCTAssert(person.lastName == "Bell", "Last name was wrong")
            XCTAssert(person.jobTitle == "Producer", "Job Title was wrong")
            XCTAssert(person.organization == "Creative Consulting", "Organization was wrong")
            XCTAssert(person.phoneNumbers != nil, "Phone numbers collection was nil")
            if let phoneNumbers = person.phoneNumbers {
                XCTAssert(phoneNumbers.count == 2, "Wrong phone number count")
                XCTAssert(phoneNumbers[0].label == "mobile", "Incorrect first phone label")
                XCTAssert(phoneNumbers[0].value == "(555) 564-8583", "Incorrect first phone number")
                XCTAssert(phoneNumbers[1].label == "main", "Incorrect second phone label")
                XCTAssert(phoneNumbers[1].value == "(415) 555-3695", "Incorrect second phone number")
            }
            XCTAssert(person.phoneNumbers != nil, "Email collection was nil")
            if let emails = person.emails {
                XCTAssert(emails.count == 2, "Wrong email count")
                XCTAssert(emails[0].label == "work", "Incorrect first email label")
                XCTAssert(emails[0].value == "kate-bell@mac.com", "Incorrect first email")
                XCTAssert(emails[1].label == "work", "Incorrect second email label")
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
            XCTAssert(person.birthday == getDate(1978, 1, 20), "Incorrect birthday (was \(person.birthday))")
        }
    }
    
    func testAddRemovePerson() {
        var person: SwiftAddressBookPerson? = SwiftAddressBookPerson.create()
        var timeStamp = getDateTimestamp()
        if let person = person {
            
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
        
        person = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Darth" + timeStamp }).first
        XCTAssertNotNil(person, "Couldn't find newly added person")
        
        if let person = person {
            XCTAssert(person.firstName == "Test", "Failed to save first name")
            XCTAssert(person.lastName == "Person", "Failed to save last name")
            XCTAssert(person.nickname == "Dude", "Failed to save nickname")
            
            swiftAddressBook?.removeRecord(person)
            swiftAddressBook?.save()
        }
    }
    
    func testAddEditRemovePerson() {
        var person: SwiftAddressBookPerson? = SwiftAddressBookPerson.create()
        var timeStamp = getDateTimestamp()
        if let person = person {
            person.firstName = "Test" + timeStamp;
            swiftAddressBook?.addRecord(person)
            swiftAddressBook?.save()
        }
        
        person = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Test" + timeStamp }).first
        XCTAssertNotNil(person, "Couldn't find newly added person")
        
        if person != nil {
            if let person = person {
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
            
            person = swiftAddressBook?.allPeople?.filter({ p in p.firstName == "Darth" + timeStamp }).first
            XCTAssertNotNil(person, "Couldn't find newly edited person")
            
            if let person = person {
                
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
