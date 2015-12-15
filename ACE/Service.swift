//
//  Service.swift
//  ace-model
//
//  Created by David Morrison on 18/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class Service: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var desc = ""
    
    // contact info
    dynamic var telephone = ""
    dynamic var email = ""
    dynamic var mobile = ""
    dynamic var fax = ""
    dynamic var website = ""
    dynamic var supportOptions = ""
    dynamic var referralMethod = ""
    dynamic var recoveryHubs = ""
    dynamic var businessTimesExtraInfo = ""

    // relationships
    var businessTimes = List<BusinessTime>()
    dynamic var venue: Venue?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class BusinessTime: Object {
    dynamic var open = NSDate()
    dynamic var close = NSDate()
    dynamic var monday = false
    dynamic var tuesday = false
    dynamic var wednesday = false
    dynamic var thursday = false
    dynamic var friday = false
    dynamic var saturday = false
    dynamic var sunday = false
}