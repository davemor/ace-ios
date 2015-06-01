//
//  PictureDiaryEntry.swift
//  ACE
//
//  Created by David Morrison on 01/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class PictureDiaryEntry: Object, DiaryEntry {
    dynamic var myDate = NSDate()
    dynamic var imagePath = ""
    
    var date:NSDate {
        return myDate
    }
}