//
//  ViewController.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    var contactsManager:ContactsManager?
    var router:ContactsModuleRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsManager?.fwtchContacts()
    }

    
    
    func fetchedContactsSuccess(contacts:[ContactModel]) {
        print(contacts)
        
    }

}

