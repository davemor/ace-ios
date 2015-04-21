//
//  Service.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Service : Printable {
    
    let id:Int
    let name:String
    let description:String
    let telephone:String
    let venueId:Int
    let email:String
    let mobile:String
    let fax:String
    let website:String
    let supportOptions:String
    let referralMethod:String
    let recoveryHubs:String
    let businessTimesExtraInfo:String
    let businessTimes:[BusinessTime]
    
    struct BusinessTime {
        let open:NSDate
        let close:NSDate
        let monday, tuesday, wednesday,
            thursday, friday, saturday,
            sunday:Bool
        
        init(dict: NSDictionary) {
            open = readDate("opening_time", dict)
            close = readDate("closing_time", dict)
            monday = read("monday", dict, false)
            tuesday = read("tuesday", dict, false)
            wednesday = read("wednesday", dict, false)
            thursday = read("thursday", dict, false)
            friday = read("friday", dict, false)
            saturday = read("saturday", dict, false)
            sunday = read("sunday", dict, false)
        }
    }
    
    init(dict: NSDictionary) {
        self.id = read("id", dict, 0)
        self.name = read("name", dict, "")
        self.description = read("description", dict, "")
        self.telephone = read("telephone", dict, "")
        self.venueId = read("venue_id", dict, 0)
        self.email = read("emain", dict, "")
        self.mobile = read("mobile", dict, "")
        self.fax = read("fax", dict, "")
        self.website = read("website", dict, "")
        self.supportOptions = read("support_options", dict, "")
        self.referralMethod = read("referral_method", dict, "")
        self.recoveryHubs = read("recovery_hubs", dict, "")
        self.businessTimesExtraInfo = read("business_times_extra_info", dict, "")
        if let times = dict.objectForKey("business_times") as? NSArray {
            var ts = [BusinessTime]()
            for time in times {
                ts.append(BusinessTime(dict: time as! NSDictionary))
            }
            businessTimes = ts
        } else {
            businessTimes = []
        }
        // add to venue
        Venue.all[self.venueId]?.services.append(self)
    }
    
    // access to the collection of all venues
    static var all:[Int:Service]  = [Int:Service]()
    
    // helper functions
    var displayName: String {
        return name
    }
}