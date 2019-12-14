//
//  ContactsAPIConnector.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class ContactsAPIConnector :DataConnector{
    
    static let shared = ContactsAPIConnector()
    let baseURL = "https://s3-sa-east-1.amazonaws.com"
    let contactsPath = "/rgasp-mobile-test/v1/"
    let contactsFileName = "content.json"
    
    func getContacts(completion: @escaping QueryResut) {
        if let urlComponents = URLComponents(string: baseURL + contactsPath + contactsFileName) {
            guard let url = urlComponents.url else { return }
            self.requestContacts(url: url, completionHandler: completion)
        }
    }
    
    func requestContacts(url: URL, completionHandler: @escaping QueryResut){
        
        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let dataArray = response.value as? [Dictionary<String , Any>] else {
                        completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from fetchAllRooms service"]))
                        return
                    }
                    let contacts:[ContactModel] = dataArray.compactMap(ContactModel.init)
                    completionHandler(contacts, nil)

                case .failure:
                     completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Resource not found"]))
                }
        }
    }
    
    static func downloadImage(from url: String, completion: @escaping (UIImage?) -> ()) {
       
      
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            
            AF.request(url, method: .get)
                .validate()
                .responseData(completionHandler: { (response) in
                    
                    switch response.result {
                    case .success:
                        guard response.data != nil, let image = UIImage(data:response.data!) else {
                            completion(nil)
                            return
                        }
                        completion(image)
                        
                    case .failure:
                        completion(nil)

                    }
                })
        }   
    }
}

