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
    var open = NSDate()
    var close = NSDate()
    var monday = false
    var tuesday = false
    var wednesday = false
    var thursday = false
    var friday = false
    var saturday = false
    var sunday = false
}