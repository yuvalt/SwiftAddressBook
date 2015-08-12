//
//  SwiftAddressBookRecord.swift
//  Pods
//
//  Created by Socialbit - Tassilo Karge on 09.03.15.
//
//

import Foundation
import AddressBook

//MARK: Wrapper for ABAddressBookRecord

public class SwiftAddressBookRecord {

	public var internalRecord : ABRecord

	init(record : ABRecord) {
		internalRecord = record
	}

	public var recordID: Int {
		get {
			return Int(ABRecordGetRecordID(self.internalRecord))
		}
    }
    
    public var recordType: SwiftAddressBookRecordType {
        get {
            return SwiftAddressBookRecordType(abRecordType: ABRecordGetRecordType(self.internalRecord))
        }
    }

	public func convertToSource() -> SwiftAddressBookSource? {
        return self as? SwiftAddressBookSource
	}

	public func convertToGroup() -> SwiftAddressBookGroup? {
		return self as? SwiftAddressBookGroup
	}

    public func convertToPerson() -> SwiftAddressBookPerson? {
        return self as? SwiftAddressBookPerson
	}
}
