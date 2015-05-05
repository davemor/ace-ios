//
//  Group.swift
//  ACE
//
//  Created by David Morrison on 19/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Group {
    let id:Int
    let name:String
    let description:String
    let contactName:String
    let telephone:String
    
    init(dict: NSDictionary) {
        id = read("id", dict, 0)
        name = read("name", dict, "")
        description = read("description", dict, "")
        contactName = read("contact_name", dict, "")
        telephone = read("telephone", dict, "")
    }
    
    static var all:[Int:Group]  = [Int:Group]()
    static func find(id:Int) -> Group? {
        return all[id]
    }
}