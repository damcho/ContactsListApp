//
//  ContactsListAppTests.swift
//  ContactsListAppTests
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import XCTest
@testable import ContactsListApp

class ModelObjectsTests: XCTestCase {

    let dateFormatter = DateFormatter()

    
    override func setUp() {
     
    }
    
    func createContact() -> ContactModel {
        let contact = ContactModel()
        contact.biography = "some biography"
        dateFormatter.dateFormat = "MM/dd/yyyy"
        contact.born = dateFormatter.date(from: "12/12/1222")
        contact.name = "some name"
        contact.email = "some@email.com"
        return contact
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContactModelValidation() {
        var error:NSError?
        var contact:ContactModel
        contact = createContact()
        error = contact.hasErrors() as NSError?
        XCTAssertNil(error)
        
        contact = createContact()
        contact.name = ""
        error = contact.hasErrors() as NSError?
        XCTAssertEqual(error?.code,0 )
        
        contact = createContact()
        contact.email = "someemail@email"
        error = contact.hasErrors() as NSError?
        XCTAssertEqual(error?.code,1)
        
        contact = createContact()
        contact.born = dateFormatter.date(from:"12/12/")
        error = contact.hasErrors() as NSError?
        XCTAssertEqual(error?.code,2 )
        
        contact = createContact()
        contact.biography = ""
        error = contact.hasErrors() as NSError?
        XCTAssertEqual(error?.code,3 )
    }
    
    func testContactEquality() {
        let contact1 = createContact()
        let contact2 = createContact()
        XCTAssertEqual(contact1, contact2)
        
        contact2.email = "different@email.com"
        XCTAssertNotEqual(contact2, contact1)
    }

}
