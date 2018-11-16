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
    /*
    static func decodeError(data:Data) throws -> Error {
        let decodedError =  try  JSONDecoder().decode(DecodedError.self, from: data)
        let error = NSError(domain: "", code: decodedError.errorCode, userInfo: [NSLocalizedDescriptionKey:decodedError.errorDescription ])
        return error
    }
 
 */
}

private struct DecodedContacts:Decodable {
    let results:[DecodedContact]
}

struct DecodedContact: Decodable {
    
    let contactName:String
    let contactEmail:String
    let contactBio:String
    let contactPhotoURL:String
    let contactBDate:String
    
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
        self.contactBDate = try container.decode(String.self, forKey: .contactBDate)
        self.contactEmail = try container.decode(String.self, forKey: .contactEmail)
        self.contactPhotoURL = try container.decode(String.self, forKey: .contactPhotoURL)
    }
}

struct DecodedError: Decodable {
    let errorCode:Int
    let errorDescription:String
    
    enum CodingKeys : String, CodingKey {
        
        case errorcode = "status_code"
        case errordesc = "status_message"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorDescription = try container.decode(String.self, forKey: .errordesc)
        self.errorCode = try container.decode(Int.self, forKey: .errorcode)
    }
}

