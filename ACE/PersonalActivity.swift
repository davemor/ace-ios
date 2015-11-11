//
//  PersonalActivity.swift
//  ACE
//
//  Created by David Morrison on 26/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class PersonalActivity: Object, Activity {

    dynamic var id = 0
    
    dynamic var isAttending = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Implement the Activity Protocol
    var name = ""
    var desc = ""
    var start = NSDate()
    var end = NSDate()
    var `repeat` = Repeat.none
    var url: String?
    var venue:Venue? = Venue()
    var attending: Bool {
        get { return isAttending }
        set { isAttending = newValue }
    }
    var color: UIColor  {
        get { return UIColor.grayColor() }
    }
}