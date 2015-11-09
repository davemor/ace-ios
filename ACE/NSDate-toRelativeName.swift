//
//  NSDate.swift
//  ARC
//
//  Created by Andrew Sage on 09/11/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import UIKit
import Foundation
extension NSDate {
    func toRelativeName() -> String {
        var name = self.toString()
        if isToday() {
            name = "Today"
        } else if isYesterday() {
            name = "Yesterday"
        } else if isThisWeek() {
            name = self.weekdayToString()
        } else if isLastWeek() {
            name = "Last week"
        } else {
            name = self.toString()
        }
        return name
    }
}
