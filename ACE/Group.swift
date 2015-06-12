//
//  Group.swift
//  ace-model
//
//  Created by David Morrison on 18/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Group: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var contactName = ""
    dynamic var telephone = ""
    
    static override func primaryKey() -> String? {
        return "id"
    }
    
    var meetings: [Meeting] {
        return linkingObjects(Meeting.self, forProperty: "group")
    }
    
    var color: UIColor {
        return getColorForGroup(name)
    }
}