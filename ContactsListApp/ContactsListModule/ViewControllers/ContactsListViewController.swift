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
    
    @IBOutlet weak var refreshListButton: UIButton!
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
        setupListeners()
        fetchContacts()
    }
    
    func setupListeners() {
        self.setupDatafetchWithSuccess()
        self.setupDataFetcWithError()
    }
    
    func setupDataFetcWithError() {
        
        self.contactsManager!.dataRetrievedWithError = { [unowned self] error in
            self.activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            self.showAlertView(msg: error.localizedDescription)
        }
    }
    func setupDatafetchWithSuccess() {
        self.contactsManager!.dataRetrievedWithSuccess = { [unowned self] contacts in
            self.activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            self.contacts = contacts
            self.contactsTableView.isHidden = self.contacts!.isEmpty
            self.refreshListButton.isHidden = !self.contacts!.isEmpty
            if self.contacts!.isEmpty {
                self.showAlertView(msg: "No results")
            } else {
                self.contactsTableView.reloadData()
            }
        }
    }
    
    func fetchContacts() {
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        contactsManager?.fwtchContacts()
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
        
        cell.setCell(contact: (self.contactsManager?.getContacAtIndex(index:indexPath))!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.contactsManager?.getContacAtIndex(index: indexPath)
        self.router?.pushToContactDetail(navController:navigationController!, contact:contact)
    }
    
    @IBAction func onRefreshButtonTapped(_ sender: Any) {
        fetchContacts()
    }
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)    {
        if editingStyle == .delete
        {
            self.contactsTableView.beginUpdates()
            self.contactsManager!.deleteContact(index:indexPath)
            self.contactsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.contactsTableView.endUpdates()
        }
    }
}

