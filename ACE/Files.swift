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
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsPath = paths[0]
    
    return (documentsPath as NSString).stringByAppendingPathComponent(filename)
}

func generateUniqueFileName() -> String {
    // create a unique file name for the image
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss-SSS" // ms for a unique filename
    let now = NSDate()
    let dateStr = dateFormatter.stringFromDate(now)
    let randomStr = String(arc4random_uniform(256)) // and a random number
    let fileName = dateStr + randomStr
    return fileName
}

func makePathForImage(fileName: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsPath = paths[0]
    let fullPath = (documentsPath as NSString).stringByAppendingPathComponent(fileName) + ".png"
    return fullPath
}

func saveAsPNG(image: UIImage, fullPath: String) {
    // save the image to our local directory so the app can get it back
    if let pngData = UIImagePNGRepresentation(image) {
        pngData.writeToFile(fullPath, atomically: true)
    } else {
        print("Error writing PNG to file in PhotoViewController.")
    }
}