//
//  Service.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

/*
id: 1,
name: "Aberlour Family Outreach Edinburgh",
description: "Aberlour Family Outreach Edinburgh works with ...",
telephone: "0131 659 2942",
venue_id: 107,
created_at: "2015-04-16T09:38:08.171Z",
updated_at: "2015-04-16T09:38:08.171Z",
email: "edinburgh.outreach@aberlour.org.uk",
mobile: null,
fax: "0131 659 2947",
website: "http://www.aberlour.org.uk/outreachedinburgh.aspx",
support_options: "Intensive family support programme. Parenting skills training.",
referral_method: "By telephone.",
recovery_hubs: null,
business_times_extra_info: "Enquiries can be made during normal office hours."
*/

struct Service: Printable {
    var id:Int
    var name:String
    var description:String
    var telephone:String
    var venueId:Int
    var email:String
    var mobile:String
    var fax:String
    var website:String
    var supportOptions:String
    var referralMethod:String
    var recoveryHubs:String
    var businessTimesExtraInfo:String
    /*
    init(dict: NSDictionary) {
        /*
        self.id:Int
        self.name:String
        self.description:String
        self.telephone:String
        self.venueId:Int
        self.email:String
        self.mobile:String
        self.fax:String
        self.website:String
        self.supportOptions:String
        self.referralMethod:String
        self.recoveryHubs:String
        self.businessTimesExtraInfo:String
        */
    }
    */
}