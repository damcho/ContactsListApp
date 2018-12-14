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
    var photoData:Data?
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let validDate = dateFormatter.date(from: data["born"] as! String) else {
            self.born = Date()
            return
        }
        self.born = validDate
        self.photoURL = data["photo"] as? String
    }
    
    
    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.email == rhs.email
    }
    
    func populate(data:ContactModel) {
        self.name = data.name
        self.biography = data.biography
        self.email = data.email
        self.born = data.born
        self.photoData = data.photoData
        self.photoURL = data.photoURL
    }
    
    func getImage(completion: @escaping (UIImage) -> ()){
        
        let handler = { [unowned self] (data:Data?) -> () in
            if data != nil {
                guard let image = UIImage(data:data!) else {
                    completion(UIImage(named: "contactdefault")!)
                    return
                }
                self.photoData = data
                ContactsDBConnector.shared.save(imageData: self.photoData!, with: self.photoURL!, and: nil)
                completion(image)
            }
        }
        
        if self.photoData != nil {
            completion(UIImage(data:self.photoData!)!)
        } else if self.photoURL == nil{
            completion(UIImage(named: "contactdefault")!)
        } else {
            ContactsManager.getImage(path: self.photoURL!, completion: handler)
        }
    }
    
    func validate() -> Error? {
        if !isValidName() {
            return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"You must enter a name"])
        } else if self.email != nil && !self.email!.isValidEmail() {
            return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey:"You must enter a valid e-mail"])
        } else if self.born == nil{
            return NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey:"Invalid birth date format"])
        } else if !isValidBiography(){
            return NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey:"You must enter a small biography"])
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
