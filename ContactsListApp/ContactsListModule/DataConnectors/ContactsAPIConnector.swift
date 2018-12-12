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
    
    init() {
        Reachability.listenForReachability()
    }
    
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
                guard response.result.isSuccess else {
                    completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Resource not found"]))
                    return
                }
                guard let dataArray = response.result.value as? [Dictionary<String , Any>] else {
                    completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from fetchAllRooms service"]))
                    return
                }
                
                let contacts:[ContactModel] = dataArray.compactMap(ContactModel.init)
                completionHandler(contacts, nil)
        }
    }
    
    static func downloadImage(from url: String, completion: @escaping (Data?) -> ()) {
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            
            AF.request(url, method: .get)
                .validate()
                .responseData(completionHandler: { (responseData) in
                    guard let image = responseData.data else {
                        completion(nil)
                        return
                    }
                    completion(image)
                })
        }
    }
}


public class Reachability {
    
    static let reachabilityManager = Alamofire.NetworkReachabilityManager (host: "www.apple.com")
    static func listenForReachability() {
        reachabilityManager!.startListening()
    }
    
    static func isConnectedToNetwork() -> Bool{
        return reachabilityManager!.isReachable
    }
}

