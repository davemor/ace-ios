//
//  Contact.swift
//  ACE
//
//  Created by David Morrison on 09/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Contact {
    let id:Int
    let name: String
    let phone: String
    let textInEmergency: Bool
    let phoneInEmergency: Bool
    init(id:Int, name:String, phone:String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.textInEmergency = false
        self.phoneInEmergency = false
    }
    
    private static var contacts:[Int:Contact]  = [
        0 : Contact(id: 0, name: "Dave", phone: "07595332186"),
        1 : Contact(id: 1, name: "Mike", phone: "123456789"),
        2 : Contact(id: 2, name: "Danny", phone: "0987654321")
    ]
    static var all: [Contact] {
        return contacts.toArray { $1 }
    }
    static func find(id:Int) -> Contact? {
        return contacts[id]
    }
    static func remove(id:Int) {
        contacts.removeValueForKey(id)
    }
    static func create(name:String, phone:String) -> Int {
        let contact = Contact(id: all.count, name: name, phone: phone)
        contacts[contact.id] = contact
        return contact.id
    }
}