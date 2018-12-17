//
//  ContactModel.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit
class ContactModel : Equatable{
    
    var name:String?
    var email:String?
    var born:Date?
    var biography:String?
    var photoURL:String?
    
    init() {
        self.name = ""
        self.biography = ""
        self.email = ""
        self.born = Date()
    }
    
    init?(data:Dictionary<String, Any>) {
        self.name = data["name"] as? String
        self.biography = data["bio"] as? String
        self.email = data["email"] as? String
        self.photoURL = data["photo"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let validDate = dateFormatter.date(from: data["born"] as! String) else {
            self.born = Date()
            return
        }
        self.born = validDate
        
    }
    
    
    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.email == rhs.email
    }
    
    func populate(data:ContactModel) {
        self.name = data.name
        self.biography = data.biography
        self.email = data.email
        self.born = data.born
        self.photoURL = data.photoURL
    }
    
    func getImage(completion: @escaping (UIImage?) -> ()){
        ContactsManager.getImage(path: self.photoURL!, completion: completion)
    }
    
    func hasErrors() -> Error? {
        if !isValidName() {
            return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid Name"])
        } else if self.email != nil && !self.email!.isValidEmail() {
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey:"Invalid e-mail"])
        } else if self.born == nil{
            return NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey:"Invalid birth date"])
        } else if !isValidBiography(){
            return NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey:"Invalid Biography"])
        }
        
        return nil
    }
    
    func isValidName() -> Bool {
        return self.name != ""
    }
    
    func isValidBiography() -> Bool {
        return self.biography != ""
    }
}
