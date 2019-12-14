//
//  ContactsListViewModel.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class ContactsManager {
    
    static let imageCache = NSCache<NSString, UIImage>()
    var apiConnector: DataConnector
    var coredataConnector: DataConnector
    var contacts:[ContactModel]?
    var dataRetrievedWithSuccess:(([ContactModel]) -> ())?
    var dataRetrievedWithError:((Error) -> ())?
    var contctSavedWithSuccess:(() -> ())?
    var contactSavedWithError:((Error) ->())?
    
    init(apiConnector: DataConnector = ContactsAPIConnector.shared, dbConnector: DataConnector = ContactsDBConnector.shared) {
        self.apiConnector = apiConnector
        self.coredataConnector = dbConnector
    }
    
    func fwtchContacts() {
        self.requestContactsFromAPI()
    }
    
    func requestContactsFromDB() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            guard let contacts = contacts else {
                self.dataRetrievedWithError?(error!)
                return
            }
            self.dataRetrievedWithSuccess?(contacts)
        }
        
        self.coredataConnector.getContacts(completion:handler)
    }
    
    func requestContactsFromAPI() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            guard let retrievedContaacts = contacts else {
                self.requestContactsFromDB()
                return
            }
            do {
                try self.coredataConnector.storeContacts(contacts:retrievedContaacts)
            } catch let error {
                self.dataRetrievedWithError?(error)
            }
            self.dataRetrievedWithSuccess?(retrievedContaacts)
        }
        
        self.apiConnector.getContacts(completion:handler)
    }
    
    func getContacAtIndex(index:IndexPath) -> ContactModel {
        return self.contacts![index.row]
    }
    
    func contactsCount() -> Int {
        guard let contacts = self.contacts else {
            return 0
        }
        return contacts.count
    }
    
    func saveContact(newContact:ContactModel) {
        let error = newContact.hasErrors()
        
        if error == nil{
            
            if self.contacts?.contains(where: { $0 == newContact }) == false{
                self.contacts?.append(newContact)
            }
            do {
                try self.coredataConnector.storeContacts(contacts:self.contacts!)
                contctSavedWithSuccess?()
            } catch let error {
                contactSavedWithError?( error)
            }
        } else {
            contactSavedWithError?(error!)
        }
    }
    
    func deleteContact(index:IndexPath) {
        if self.contacts != nil, index.row <= self.contacts?.count ?? 0{
            let contact = self.contacts![index.row]
            self.contacts?.remove(at: index.row)
            self.coredataConnector.deleteContact(contact:contact)
        }
    }
    
    class func getImage(path:String, completion: @escaping (UIImage?) -> ()){
        
        if let cachedImage = imageCache.object(forKey: path as NSString) {
            completion(cachedImage)
            return
        }
        
        let downloadedImageHandler = { (image:UIImage?) in
            if let retrievedImage = image {
                imageCache.setObject(retrievedImage, forKey: path as NSString)
                ContactsDBConnector.shared.save(imageData: retrievedImage.pngData()!, with: path, and: nil)
                completion(retrievedImage)
                return
            } else {
                guard let imageData = ContactsDBConnector.shared.load(fileName: path),
                    let image = UIImage(data:imageData) else {
                        completion(nil)
                        return
                    }
                completion(image)
            }
        }
        
        ContactsAPIConnector.downloadImage(from:path, completion:downloadedImageHandler)
    }
}




