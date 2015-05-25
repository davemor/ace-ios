//
//  Activity.swift
//  ACE
//
//  Created by David Morrison on 21/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {
    dynamic var id = 0
    
    // activities point at meetings
    // when you add a meeting to a calendar
    dynamic var meeting: Meeting?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}