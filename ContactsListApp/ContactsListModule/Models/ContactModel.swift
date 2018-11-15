//
//  ContactModel.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ContactModel {
    
    var name:String
    var email:String
    var born:String
    var biography:String
    var photoURL:URL?
    var photoData:Data?
    
    
    init() {
        self.name = ""
        self.biography = ""
        self.email = ""
        self.born = ""
    }
    
    init(data:DecodedContact) {
        self.name = data.contactName
        self.biography = data.contactBio
        self.email = data.contactEmail
        self.photoURL = data.contactPhotoURL
        self.born = data.contactBDate

    }
    
}
