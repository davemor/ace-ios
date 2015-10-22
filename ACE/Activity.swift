//
//  Activity.swift
//  ACE
//
//  Created by David Morrison on 21/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

protocol Activity {
    var name: String { get }
    var desc: String { get }
    
    var start: NSDate { get }
    var end: NSDate { get }
    var `repeat`: Repeat { get }
    
    var url: String? { get }
    var venue: Venue? { get }
    
    var attending: Bool { get set }
}