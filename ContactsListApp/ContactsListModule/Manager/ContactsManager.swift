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
    
    let apiConnector = ContactsAPIConnector.shared
    let coredataConnector = ContactsDBConnector.shared
    var contacts:[ContactModel]?
    var dataRetrievedWithSuccess:(([ContactModel]) -> ())?
    var dataRetrievedWithError:((Error) -> ())?
    var contctSavedWithSuccess:(() -> ())?
    var contactSavedWithError:((Error) ->())?
    
    func fwtchContacts() {
        if contactsInMemory() {
            self.dataRetrievedWithSuccess?(self.contacts!)
        } else if Reachability.isConnectedToNetwork() {
            self.requestContactsFromAPI()
        } else {
            self.requestMoviesFromDB()
        }
    }
    
    func contactsInMemory() -> Bool {
        return self.contacts != nil && self.contacts!.isEmpty == false
    }
    
    func requestMoviesFromDB() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            if contacts != nil {
                self.dataRetrievedWithSuccess?(self.contacts!)
            } else {
                self.dataRetrievedWithError?(error!)
            }
        }
        self.coredataConnector.getContacts(completion:handler)
    }
    
    func requestContactsFromAPI() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            guard let retrievedContaacts = contacts else {
                self.dataRetrievedWithError?(error!)
                return
            }
            do {
                try self.coredataConnector.storeContacts(contacts:retrievedContaacts)
            } catch let error {
                self.dataRetrievedWithError?(error)
            }
            self.dataRetrievedWithSuccess?(self.contacts!)
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
        let errors = newContact.hasErrors()
        if errors == nil{
            
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
            contactSavedWithError?(errors!)
        }
    }
    
    func deleteContact(index:IndexPath) {
        let contact = self.contacts![index.row]
        self.contacts!.remove(at: index.row)
        self.coredataConnector.deleteContact(contact:contact)
    }
    
    class func getImage(path:String, completion: @escaping (UIImage?) -> ()){
        let downloadedImageHandler = { (image:UIImage?) in
            if image != nil {
                ContactsDBConnector.shared.save(imageData: image!.pngData()!, with: path, and: nil)
            }
            completion(image)
        }
        
        if Reachability.isConnectedToNetwork() {
            ContactsAPIConnector.downloadImage(from:path, completion:downloadedImageHandler)
        } else {
            guard let imageData = ContactsDBConnector.shared.load(fileName: path) else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}




