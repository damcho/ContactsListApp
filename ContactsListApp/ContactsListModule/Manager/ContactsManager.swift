//
//  ContactsListViewModel.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ContactsManager {
    
    let apiConnector = ContactsAPIConnector.shared
    let coredataConnector = ContactsDBConnector.shared
    var contacts:[ContactModel]?
    weak var contactsListViewController:ContactsListViewController?
    weak var contactDetailViewController:ContacDetailViewController?

    func fwtchContacts() {
        if self.contacts != nil {
            self.contactsListViewController?.fetchedContactsSuccess( contacts: self.contacts! )
        } else if Reachability.isConnectedToNetwork() {
            self.requestContactsFromAPI()
        } else {
            self.requestMoviesFromDB()
        }
    }
    
    func requestMoviesFromDB() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            if contacts != nil {
                self.contactsListViewController?.fetchedContactsSuccess( contacts: self.contacts! )
            } else {
                self.contactsListViewController?.fetchedContactsError(error:error!)
            }
        }
        self.coredataConnector.getContacts(completion:handler)
    }
    
    func requestContactsFromAPI() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            if contacts != nil {
                do {
                    try self.coredataConnector.storeContacts(contacts:self.contacts!)
                } catch let error {
                    self.contactsListViewController?.fetchedContactsError(error:error)
                }
                self.contactsListViewController?.fetchedContactsSuccess( contacts: self.contacts! )
            } else {
                self.contactsListViewController?.fetchedContactsError(error:error!)
            }
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
        if self.contacts?.contains(where: { $0 == newContact }) == false{
            self.contacts?.append(newContact)
        }
        do {
            try self.coredataConnector.storeContacts(contacts:self.contacts!)
            contactDetailViewController?.contctSavedWithSuccess()
        } catch let error {
            contactDetailViewController?.failureSavingContact(error: error)
        }
    }
    
    class func getImage(path:String, completion: @escaping (Data) -> ()){
        ContactsAPIConnector.downloadImage(from:path, completion:completion)
    }
    
    
}




