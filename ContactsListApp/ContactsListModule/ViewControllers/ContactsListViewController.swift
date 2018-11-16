//
//  ViewController.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactsTableView: UITableView!
    var contactsManager:ContactsManager?
    var router:ContactsModuleRouter?
    var contacts:[ContactModel]?
    let activityData = ActivityData()
    var activityIndicatorView:NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        contactsManager?.fwtchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contactsTableView.reloadData()
    }
    
    
    @objc func addTapped() {
        self.router?.pushToContactDetail(navController:navigationController!, contact:nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.contactsManager?.contactsCount())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath as IndexPath) as! ContactTableViewCell
        
        cell.setCell(contact: self.contactsManager!.getContacAtIndex(index:indexPath))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.contactsManager?.getContacAtIndex(index: indexPath)
        self.router?.pushToContactDetail(navController:navigationController!, contact:contact)
    }
    
    
    func fetchedContactsError(error:Error) {
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        showAlertView(msg: error.localizedDescription)
    }
    
    func fetchedContactsSuccess(contacts:[ContactModel]) {
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        self.contacts = contacts
        self.contactsTableView.reloadData()
    }
}

