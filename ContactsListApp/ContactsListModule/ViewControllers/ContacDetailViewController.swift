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
    var contactsManager:ContactsManager?

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nameInputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameInputLabel: UILabel!
    
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
            self.nameTextField.isHidden = true
            self.nameInputLabel.isHidden = true

            self.bioTextView.isUserInteractionEnabled = false
            self.bioTextView.isEditable = false

            self.birthTextField.isUserInteractionEnabled = false
            self.birthTextField.isEnabled = false

            self.emailTextField.isUserInteractionEnabled = false
            self.emailTextField.isEnabled = false

            
            contact?.getImage(completion: { (data:Data) in
                self.contactImageView.image = UIImage(data: data)
            })

            self.nameTextField.text = self.contact?.name
            self.birthTextField.text = self.contact?.born

        }
    }
    
    @objc func saveTapped() {
        print("saveTapped")
        contact?.name = nameTextField.text!
        contact?.biography = bioTextView.text!
        contact?.email = emailTextField.text!

        if let error = contact?.validate() {
            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.setupView()

    }
    
    @objc func editTapped() {
        print("editTapped")
        self.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))

        nameInputHeightConstraint.constant = 30
        self.nameTextField.isHidden = false
        self.nameTextField.isEnabled = true
        self.nameTextField.isUserInteractionEnabled = true
        
        self.bioTextView.isUserInteractionEnabled = true
        self.bioTextView.isEditable = true

        self.birthTextField.isUserInteractionEnabled = true
        self.birthTextField.isEnabled = true
        
        self.emailTextField.isUserInteractionEnabled = true
        self.emailTextField.isEnabled = true

        self.nameInputLabel.isHidden = false
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
