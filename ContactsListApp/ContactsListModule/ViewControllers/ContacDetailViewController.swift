//
//  ContacDetailViewController.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class ContacDetailViewController: UIViewController, UITextFieldDelegate {

    var contact:ContactModel?
    var newContact:ContactModel?

    var contactsManager:ContactsManager?

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nameInputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameInputLabelHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        if contact == nil {
            contact = ContactModel()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
            self.title = "Create contact"
            self.nameTextField.placeholder = "Insert name"
            self.birthTextField.placeholder = "mm/dd/yyyy"
            self.emailTextField.placeholder = "Insert e-mail"
            self.bioTextView.text = "Insert biography"
            self.bioTextView.textColor = UIColor.lightGray
            self.contactImageView.image = #imageLiteral(resourceName: "default")

        } else {
            self.title = contact?.name
               navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            nameInputHeightConstraint.constant = 0
            nameInputLabelHeightConstraint.constant = 0
            self.nameTextField.isHidden = true
            self.bioTextView.isEditable = false
            self.birthTextField.isEnabled = false
            self.emailTextField.isEnabled = false
            
            contact?.getImage(completion: { (data:Data) in
                self.contactImageView.image = UIImage(data: data)
            })
            self.nameTextField.text = self.contact?.name
            self.birthTextField.text = self.contact?.born
            self.emailTextField.text = self.contact?.email
            self.bioTextView.text = self.contact?.biography
        }
    }
    
    @objc func saveTapped() {
        newContact = ContactModel()
        newContact!.name = nameTextField.text!
        newContact!.biography = bioTextView.text!
        newContact!.email = emailTextField.text!

        if let error = newContact?.validate() {
            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.contact!.update(newContact:newContact!)
            self.contactsManager!.saveContact(newContact: contact!)
            self.setupView()
        }
    }
    
    @objc func editTapped() {
        self.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        self.nameTextField.isHidden = false
        self.nameInputHeightConstraint.constant = 30
        nameInputLabelHeightConstraint.constant = 30
        self.nameTextField.isEnabled = true
        self.bioTextView.isEditable = true
        self.birthTextField.isEnabled = true
        self.emailTextField.isEnabled = true
        
        UIView.animate(withDuration: 0.25,
                       animations: {
                        self.view.layoutIfNeeded()
                        
        },
                       completion:nil
        )
    }
}
