//
//  TextDiaryEntry.swift
//  ACE
//
//  Created by David Morrison on 31/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class TextDiaryEntry: Object, DiaryEntry {
    dynamic var myDate = NSDate()
    dynamic var text = ""
    
    var date:NSDate {
        return myDate
    }
}