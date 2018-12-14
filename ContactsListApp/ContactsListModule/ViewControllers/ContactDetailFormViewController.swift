//
//  ContactDetailFormViewController.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 13/12/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import Eureka

class ContactDetailFormViewController: FormViewController {
    var contact:ContactModel?
    var newContact = ContactModel()
    var contactsManager:ContactsManager?
    
    @objc func editTapped() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        self.tableView.isUserInteractionEnabled = true
        let row:NameRow = form.rowBy(tag:"nameRow")!
        row.cell.textField.becomeFirstResponder()
    }
    
    @objc func saveTapped() {
        let errors = form.validate()
        if errors.count == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            self.tableView.isUserInteractionEnabled = false
            if newContact.validate() == nil {
                self.contact!.populate(data:newContact)
                self.contactsManager!.saveContact(newContact: contact!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        self.createForm()
    }
    
    func createDataSection() -> Section {
        return Section("DataSection")
        <<< self.createNameRow()
        <<< self.createEmailRow()
        <<< self.createDateRow()
    }
    
    func createForm() {
        form += [self.createFormHeader(),
                 self.createDataSection(),
                 self.createBioSection()]
    }
    
    func createFormHeader() -> Section{
        return Section("headerSection") { section in
            
            var header = HeaderFooterView<ContactDetailHeaderView>(.nibFile(name: "ContactDetailHeaderView", bundle: nil))
            
            header.onSetupView = { view, _ in
                let header = view as ContactDetailHeaderView
                self.newContact.getImage(completion: { (image:UIImage) ->() in
                    header.ContactImageView.image  = image
                })
            }
            section.header = header
        }
    }
    
    func createNameRow() -> NameRow{
       return  NameRow("nameRow"){ row in
                row.title = "Name"
                row.placeholder = "Enter text here"
                row.value = self.contact?.name
                row.add(rule: RuleRequired())
                row.onChange { row in
                    self.newContact.name = row.value
                }
                
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
        }
        
    }
    
    func createEmailRow() -> EmailRow{
      return  EmailRow(){ row in
            row.title = "E-mail"
            row.placeholder = "Enter text here"
            row.value = self.contact?.email
            row.add(rule: RuleRequired())
            row.add(rule: RuleEmail())
            row.onChange { row in
                self.newContact.email = row.value!
            }
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
        }
    }
    
    func createDateRow() -> DateRow{
       return DateRow(){ row in
            row.title = "Birth"
            row.value = self.contact?.born
            row.add(rule: RuleRequired())
            row.onChange { row in
                self.newContact.born = row.value!
            }
        }
    }
    
    func createBioSection() -> Section{
        return Section("Biography")
            <<< TextAreaRow(){ row in
                row.title = "Biography"
                row.value = self.contact?.biography
        }
    }
    
    func setupView() {
        if self.contact == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        } else {
            self.newContact = ContactModel()
            self.newContact.populate(data:self.contact!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
        self.tableView.isUserInteractionEnabled = self.contact == nil
        
        self.title = contact == nil ? "Create contact" : contact?.name
    }
    
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }
    
    func contctSavedWithSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func failureSavingContact(error:Error) {
        showAlertView(msg: error.localizedDescription)
    }
}
