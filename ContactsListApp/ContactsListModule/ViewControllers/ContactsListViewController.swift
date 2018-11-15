//
//  ViewController.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contactsTableView: UITableView!
    var contactsManager:ContactsManager?
    var router:ContactsModuleRouter?
    var contacts:[ContactModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        contactsManager?.fwtchContacts()
    }
    
    @objc func addTapped() {
        self.router?.pushToContactDetail(navController:navigationController!, contact:nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contactsCOunt = self.contacts?.count else {
            return 0
        }
        return contactsCOunt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath as IndexPath) as! ContactTableViewCell
        
        cell.setCell(contact: self.contacts![indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.contacts![indexPath.row]
        self.router?.pushToContactDetail(navController:navigationController!, contact:contact)
    }
    

    func fetchedContactsError(error:Error) {
        showAlertView(msg: error.localizedDescription)
    }
    
    func fetchedContactsSuccess(contacts:[ContactModel]) {
        print(contacts)
        self.contacts = contacts
        self.contactsTableView.reloadData()
    }
    
    func showAlertView(msg:String) -> () {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

