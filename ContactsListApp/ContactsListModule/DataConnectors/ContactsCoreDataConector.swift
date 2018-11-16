//
//  ContactsCoreDataConector.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ContactsDBConnector: DataConnector {
    
    static let shared = ContactsDBConnector()
    
    func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func getContacts(completion: @escaping QueryResut) {
        
        let managedObjectContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        do {
            let fetchedContacts = try managedObjectContext!.fetch(fetchRequest) as! [NSManagedObject]
            var contacts:[ContactModel] = Array()
            
            for fetchedContact in fetchedContacts {
                let contact = ContactModel()
                contact.name = fetchedContact.value(forKey: "name") as! String
                contact.email = fetchedContact.value(forKey: "email") as! String
                contact.biography = fetchedContact.value(forKey:"bio") as! String
                contact.born = fetchedContact.value(forKey: "bDate") as! String
                contact.photoURL = fetchedContact.value(forKey:"photoPath") as! String
                contact.photoData = self.load(fileName: contact.photoURL)
                
                contacts.append(contact)
            }
            completion(contacts, nil)
            
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    
    func storeContacts(contacts:[ContactModel]) throws {
        
        let managedObjectContext = self.getManagedContext()
        managedObjectContext!.mergePolicy = NSOverwriteMergePolicy
        
        for contact in contacts {
            
            let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: managedObjectContext!)
            newContact.setValue(contact.name, forKeyPath: "name")
            newContact.setValue(contact.email, forKeyPath: "email")
            newContact.setValue(contact.biography, forKeyPath: "bio")
            newContact.setValue(contact.born, forKeyPath: "bDate")
            newContact.setValue(contact.photoURL, forKeyPath: "photoPath")

            do {
                try managedObjectContext!.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func save(imageData: Data, with fileName: String, and imageName: String?) {
        
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        
        let shortFileName = fileName.components(separatedBy: "v1")[1]

        let imageStore = documentsDirectory?.appendingPathComponent(shortFileName)
        print( "store: " + imageStore!.absoluteString)
        do {
            try imageData.write(to: imageStore!)
        } catch {
            print("Couldn't write the image to disk.")
        }
    }
    
    private func load(fileName: String) -> Data? {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let shortFileName = fileName.components(separatedBy: "v1")[1]

        let fileURL = documentsDirectory!.appendingPathComponent(shortFileName)
        print( "store: load " + fileURL.absoluteString)

        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
}
