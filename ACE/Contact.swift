//
//  Contact.swift
//  ace-model
//
//  Created by David Morrison on 18/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    dynamic var name = ""
    dynamic var phone = ""
    dynamic var textInEmergency = false
    dynamic var phoneInEmergency = false
    
    override static func primaryKey() -> String? {
        return "name"
    }
}