//
//  GroupsFilter.swift
//  ARC
//
//  Created by David Morrison on 28/02/2016.
//  Copyright © 2016 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

// this class acts as a way to persist a 
class Filter: Object {
    dynamic var id = 1
    dynamic var groups = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}