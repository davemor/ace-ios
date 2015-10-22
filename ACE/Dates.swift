//
//  Dates.swift
//  ACE
//
//  Created by David Morrison on 06/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import UIKit

func daysBetweenDates(startDate:NSDate, endDate:NSDate) -> Int {
    let cal = NSCalendar.currentCalendar()
    let unit:NSCalendarUnit = .Day
    let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])
    return components.day
}

/*
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    return NO;
    
    return YES;
}
*/

func dateIsBetween(date: NSDate, begin: NSDate, end: NSDate) -> Bool {
    if date.compare(begin) == NSComparisonResult.OrderedAscending {
        return false
    }
    if date.compare(end) == NSComparisonResult.OrderedDescending {
        return false
    }
    return true
}