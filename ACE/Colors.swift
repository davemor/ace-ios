//
//  Colours.swift
//  ACE
//
//  Created by David Morrison on 16/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

// this file defines some colours for the swift application

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

enum AceColor: Int{
    case Green = 0
    case Pink
    case Yellow
    case Blue
    case Purple
}

let aceColors = [
    AceColor.Green : UIColor(netHex: 0x1eb771),
    AceColor.Pink : UIColor(netHex: 0xf0177b),
    AceColor.Yellow : UIColor(netHex: 0xf99500),
    AceColor.Blue : UIColor(netHex: 0x00adf2),
    AceColor.Purple : UIColor(netHex: 0x803a9a),
]

func getRandomAceColor() -> UIColor {
    let index = Int(arc4random_uniform(5))
    return aceColors[AceColor(rawValue: index)!]!
}

func getAceColorForIndex(index: Int) -> UIColor {
    
    return aceColors[AceColor(rawValue: index % 5)!]!
    
}

func getColorForGroup(group: String) -> UIColor {
    switch group {
    case "Cocaine Anonymous": return aceColors[AceColor.Yellow]!
    case "Narcotics Anonymous": return aceColors[AceColor.Blue]!
    case "SMART Recovery Groups": return aceColors[AceColor.Pink]!
    case "Alcoholics Anonymous": return aceColors[AceColor.Purple]!
    default: return UIColor.grayColor()
    }
}