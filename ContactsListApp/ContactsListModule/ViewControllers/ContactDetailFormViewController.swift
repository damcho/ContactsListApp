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
    var isBeingEdited = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupListeners()
        self.setupView()
        self.createForm()
        self.evaluateDisabled()
    }
    
    func evaluateDisabled() {
        self.form.allRows.map{ $0.evaluateDisabled()}
    }
    
    func setupListeners() {
        self.contactsManager?.contctSavedWithSuccess = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        self.contactsManager?.contactSavedWithError = { [unowned self] (error:Error) in
            self.showAlertView(msg: error.localizedDescription)
        }
    }
    
    func setupView() {
        self.title = contact == nil ? "Create contact" : contact?.name
        self.isBeingEdited = self.contact == nil

        self.newContact = ContactModel()
        if self.contact == nil {
            contact = newContact
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        } else {
            self.newContact.populate(data:self.contact!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
    }
    
    func createForm() {
        form += [self.createFormHeader(),
                 self.createDataSection(),
                 self.createBioSection()]
    }
    
    func createDataSection() -> Section {
        return Section("DataSection")
            <<< self.createNameRow()
            <<< self.createEmailRow()
            <<< self.createDateRow()
    }
       
    func createFormHeader() -> Section{
        return Section("headerSection") { section in
            
            var header = HeaderFooterView<ContactDetailHeaderView>(.nibFile(name: "ContactDetailHeaderView", bundle: nil))
            
            header.onSetupView = { view, _ in
                let header = view as ContactDetailHeaderView
                self.newContact.getImage(completion: { (image:UIImage?) ->() in
                     header.ContactImageView.image  = image != nil ? image : UIImage(named: "contactdefault")
                })
            }
            section.header = header
        }
    }
    
    func createNameRow() -> NameRow{
        return  NameRow("nameRow"){ row in
            row.title = "Name"
            row.placeholder = "Enter text here"
            row.disabled = Condition.function(["nameRow"], { (form) -> Bool in
                return !self.isBeingEdited
            })
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
        return EmailRow("emailRow"){ row in
            row.title = "E-mail"
            row.placeholder = "Enter text here"
            row.value = self.contact?.email
            row.add(rule: RuleRequired())
            row.add(rule: RuleEmail())
            row.disabled = Condition.function(["emailRow"], { (form) -> Bool in
                return !self.isBeingEdited
            })
            row.onChange { row in
                self.newContact.email = row.value
            }
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
        }
    }
    
    func createDateRow() -> DateRow{
        return DateRow("dateRow"){ row in
            row.title = "Birth"
            row.value = self.contact?.born
            row.add(rule: RuleRequired())
            row.disabled = Condition.function(["dateRow"], { (form) -> Bool in
                return !self.isBeingEdited
            })
            row.onChange { row in
                self.newContact.born = row.value
            }
        }
    }
    
    func createBioSection() -> Section{
        return Section("Biography")
            <<< TextAreaRow("Biography"){ row in
                row.textAreaHeight = .dynamic(initialTextViewHeight: 100)
                row.title = "Biography"
                row.value = self.contact?.biography
                row.disabled = Condition.function(["Biography"], { (form) -> Bool in
                    return !self.isBeingEdited
                })
                row.onChange { row in
                    self.newContact.biography = row.value
                }
        }
    }
    
    @objc func editTapped() {
        self.isBeingEdited = true
        self.evaluateDisabled()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let row:NameRow = form.rowBy(tag:"nameRow")!
        row.cell.textField.becomeFirstResponder()
    }
    
    @objc func saveTapped() {
        let errors = form.validate()
        if errors.count == 0 {
            self.isBeingEdited = false
            self.evaluateDisabled()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            self.contact!.populate(data:newContact)
            self.contactsManager!.saveContact(newContact: contact!)
        }
    }
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }
}
