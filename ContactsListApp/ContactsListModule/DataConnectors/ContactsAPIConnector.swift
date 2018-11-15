//
//  ContactsAPIConnector.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import SystemConfiguration


enum StatusCode :Int{
    case SUCCESS = 200
}

class ContactsAPIConnector :DataConnector{
    
    
    static let shared = ContactsAPIConnector()
    
    let baseURL = "https://s3-sa-east-1.amazonaws.com"
    let contactsPath = "/rgasp-mobile-test/v1/"
    let contactsFileName = "content.json"

    let defaultSession:URLSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    func getContacts(completion: @escaping QueryResut) {
        if let urlComponents = URLComponents(string: baseURL + contactsPath + contactsFileName) {
            guard let url = urlComponents.url else { return }
            print(url)
            self.requestContacts(url: url, completionHandler: completion)
        }
    }
    
    func requestContacts(url: URL, completionHandler: @escaping QueryResut){
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse {
                do {
                    let status = StatusCode(rawValue: response.statusCode)
                    switch status {
                    case .SUCCESS?:
                        let contacts:[ContactModel] = try ContactsDecoder.decode(data: data)
                        DispatchQueue.main.async {
                            completionHandler(contacts, nil )
                        }
                        
                    default:
                        print("error")/*
                         
                      let decodedError:Error = try MovieObjectDecoder.decodeError(data: data)
                        DispatchQueue.main.async {
                            completionHandler(nil, decodedError )
                        }
 */
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completionHandler(nil, error )
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    
    func downloadImage(from url: URL, completion: @escaping (Data) -> ()) {
        
        let completionHandler = { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }
        
        self.defaultSession.dataTask(with: url, completionHandler: completionHandler).resume()
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
