//
//  Files.swift
//  ARC
//
//  Created by Andrew Sage on 18/11/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import Foundation
import UIKit

func documentPath(filename: String) -> String {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsPath = paths[0]
    
    return (documentsPath as NSString).stringByAppendingPathComponent(filename)
}