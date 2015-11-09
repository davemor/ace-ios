//
//  DiaryEntry.swift
//  ACE
//
//  Created by David Morrison on 31/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class DiaryEntry: Object {
    dynamic var id = ""

    dynamic var date = NSDate()
    dynamic var text = ""
    dynamic var imagePath = ""
    dynamic var hasImage = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}