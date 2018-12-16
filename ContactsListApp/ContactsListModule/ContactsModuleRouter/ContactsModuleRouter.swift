//
//  ContactsModuleRouter.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit


class ContactsModuleRouter {
    
    private static let manager = ContactsManager()
    
    static func createModule() -> UIViewController {
        
        let contactsListViewController = mainstoryboard.instantiateViewController(withIdentifier: "ContactsListViewController") as! ContactsListViewController
        
        let router = ContactsModuleRouter()
        
        contactsListViewController.contactsManager = manager
        contactsListViewController.router = router
        return contactsListViewController
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToContactDetail(navController:UINavigationController, contact:ContactModel?) {
        let contactForm = ContactDetailFormViewController()
        contactForm.contact = contact
        contactForm.contactsManager = ContactsModuleRouter.manager
        navController.pushViewController(contactForm,animated: true)
    }
}
