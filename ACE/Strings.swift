//
//  Strings.swift
//  ACE
//
//  Created by David Morrison on 21/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import UIKit

func condenseWhitespace(string: String) -> String {
    let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
    return join("", components)
}

func ordinalNumberFormat(num: Int) -> String {
    let ones = num % 10
    let tens = (num / 10) % 10
    var ending = ""
    if(tens == 1){
        ending = "th"
    }else {
        switch (ones) {
        case 1:
            ending = "st"
            break;
        case 2:
            ending = "nd"
            break;
        case 3:
            ending = "rd"
            break;
        default:
            ending = "th"
            break;
        }
    }
    return "\(num)\(ending)"
}