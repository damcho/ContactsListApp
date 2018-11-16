//
//  ContactsDecoder.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class ContactsDecoder {
    
    static func decode(data:Data) throws ->  [ContactModel]  {
        let decodedContacts =  try  JSONDecoder().decode([DecodedContact].self, from: data)
        var results:Array<ContactModel> = Array()
        for decodedContact in decodedContacts {
            results.append(ContactModel(data:decodedContact))
        }
        return results
    }
}

private struct DecodedContacts:Decodable {
    let results:[DecodedContact]
}

struct DecodedContact: Decodable {
    
    let contactName:String
    let contactEmail:String
    let contactBio:String
    let contactPhotoURL:String
    let contactBDate:Date?
    
    enum CodingKeys : String, CodingKey {
        
        case contactName = "name"
        case contactEmail = "email"
        case contactBio = "bio"
        case contactPhotoURL = "photo"
        case contactBDate = "born"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contactName = try container.decode(String.self, forKey: .contactName)
        self.contactBio = try container.decode(String.self, forKey: .contactBio)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = try container.decode(String.self, forKey: .contactBDate)
        self.contactBDate = dateFormatter.date(from: dateString)
        self.contactEmail = try container.decode(String.self, forKey: .contactEmail)
        self.contactPhotoURL = try container.decode(String.self, forKey: .contactPhotoURL)
    }
}




