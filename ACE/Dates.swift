//
//  Dates.swift
//  ACE
//
//  Created by David Morrison on 06/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

func daysBetweenDates(startDate:NSDate, endDate:NSDate) -> Int {
    let cal = NSCalendar.currentCalendar()
    let unit:NSCalendarUnit = .CalendarUnitDay
    let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: nil)
    return components.day
}