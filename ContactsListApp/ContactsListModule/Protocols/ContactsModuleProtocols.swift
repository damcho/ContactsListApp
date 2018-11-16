//
//  ContactsModuleProtocols.swift
//  ContactsListApp
//
//  Created by Damian Modernell on 15/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias QueryResut = ([ContactModel]?, Error?) -> ()

protocol DataConnector {
    func getContacts( completion: @escaping QueryResut )
}
