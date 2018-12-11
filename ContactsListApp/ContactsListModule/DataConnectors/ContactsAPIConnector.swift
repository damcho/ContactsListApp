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

enum StatusCode :Int{
    case SUCCESS = 200
    case NOT_FOUND = 404
}

class ContactsAPIConnector :DataConnector{
    
    
    static let shared = ContactsAPIConnector()
    
    let baseURL = "https://s3-sa-east-1.amazonaws.com"
    let contactsPath = "/rgasp-mobile-test/v1/"
    let contactsFileName = "content.json"
    
    let defaultSession:URLSession = URLSession(configuration: .default)
    
    
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
  
    static func downloadImage(from url: String, completion: @escaping (Data) -> ()) {
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            
            let completionHandler = { (data:Data?, response:URLResponse?, error:Error?) in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    completion(data)
                }
            }
            URLSession(configuration: .default).dataTask(with: url, completionHandler: completionHandler).resume()
        }
    }
}


public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
}
