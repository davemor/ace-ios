//
//  Quote.swift
//  ACE
//
//  Created by David Morrison on 16/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Quote {
    let quote:String
    let author:String
}

let quotes = loadQuotesFromJson()

func loadQuotesFromJson() -> [Quote] {

    var rtn = [Quote]()
    if let path = NSBundle.mainBundle().pathForResource("quotes", ofType: "json") {
        do {
            let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
            if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            {
                if let quotesArr : NSArray = jsonResult["quotes"] as? NSArray
                {
                    for data in quotesArr {
                        if let dict = data as? NSDictionary {
                            let text = dict.read("Quote", alt: "")
                            let author = dict.read("Author", alt: "")
                            let quote = Quote(quote: text, author: author)
                            rtn.append(quote)
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    } else {
        print("Invalid filename/path.")
    }
    return rtn
}