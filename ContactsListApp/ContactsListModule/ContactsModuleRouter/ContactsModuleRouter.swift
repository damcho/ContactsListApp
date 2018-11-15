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
    
    static func createModule() -> UIViewController {
        
        let contactsListViewController = mainstoryboard.instantiateViewController(withIdentifier: "ContactsListViewController") as! ContactsListViewController
        
        let manager = ContactsManager()
        let router = ContactsModuleRouter()
        
        contactsListViewController.contactsManager = manager
        contactsListViewController.router = router
        manager.contactsListViewController = contactsListViewController
        return contactsListViewController
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    
    func pushToMovieDetail(navController:UINavigationController, movie:ContactModel) {
        let contactDetailVC = ContactsModuleRouter.mainstoryboard.instantiateViewController(withIdentifier: "ContacDetailViewController") as! ContacDetailViewController
      //  contactDetailVC.movie = movie
    //    navController.pushViewController(movieDetailVC,animated: true)
    }
}
