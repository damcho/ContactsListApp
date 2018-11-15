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
    var contacts:[ContactModel]?
    weak var contactsListViewController:ContactsListViewController?
    
    func fwtchContacts() {
        if self.contacts != nil {
            self.contactsListViewController?.fetchedContactsSuccess( contacts: self.contacts! )
        } else if Reachability.isConnectedToNetwork() {
            self.requestContactsFromAPI()
        } else {
         //   self.requestMoviesFromDB(searchParams: searchParams)
        }
    }
    
    
    
    func requestContactsFromAPI() {
        
        let handler = {[unowned self] (contacts:[ContactModel]?, error:Error?) in
            self.contacts = contacts
            if contacts != nil {
                self.contactsListViewController?.fetchedContactsSuccess( contacts: self.contacts! )
            } else {
                self.contactsListViewController?.fetchedContactsError(error:error!)
            }
        }
        self.apiConnector.getContacts(completion:handler)
        
    }
    
    
    class func getImage(path:URL, completion: @escaping (Data) -> ()){
        ContactsAPIConnector.downloadImage(from:path, completion:completion)
    }
    
    
}




