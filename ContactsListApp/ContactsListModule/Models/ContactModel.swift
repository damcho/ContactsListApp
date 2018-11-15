//
//  ContactModel.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ContactModel : Equatable{
    
    
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
    
    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.name == rhs.name && lhs.born == rhs.born && lhs.email == rhs.email
    }
    
    func update(newContact:ContactModel) {
        self.name = newContact.name
        self.biography = newContact.biography
        self.email = newContact.email
     //   self.photoURL = data.contactPhotoURL
    //    self.born = data.contactBDate
    }
    
    func getImage(completion: @escaping (Data) -> ()){
        
        let handler = { [unowned self] (data:Data?) -> () in
            self.photoData = data
            //    TMDBCoreDataConnector.shared.save(imageData: self.imageData!, with: self.imageURLPath!, and: nil)
            completion(data!)
            
        }
        
        if self.photoData != nil {
            handler(self.photoData!)
        } else {
            ContactsManager.getImage(path: self.photoURL, completion: handler)
        }
    }
    
    func validate() -> Error? {
        var validate = true
        validate = self.name != ""
        
        if validate == false{
            return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"error"])
        }
        return nil
    }
    
}
