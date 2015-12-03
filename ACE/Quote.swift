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

/*
let quotes = [
    Quote(quote: "Keep your face always toward the sunshine - and shadows will fall behind you.", author: "Walt Whitman"),
    Quote(quote: "If you look the right way, you can see that the whole world is a garden.", author: "Frances Hodgson Burnett"),
    Quote(quote: "Keep your face always toward the sunshine - and shadows will fall behind you", author: "Walt Whitman"),
    Quote(quote: "If you look the right way, you can see that the whole world is a garden", author: "Frances Hodgson Burnett"),
    Quote(quote: "Life is very interesting... in the end, some of your greatest pains, become your greatest strengths.", author: "Drew Barrymore"),
    Quote(quote: "Determine that the thing can and shall be done, and then we shall find the way.", author: "Abraham Lincoln"),
    Quote(quote: "I am not bound to win, but I am bound to be true. I am not bound to succeed, but I am bound to live up to what light I have.", author: "Abraham Lincoln"),
    Quote(quote: "Always bear in mind that your own resolution to success is more important than any other one thing", author: "Abraham Lincoln"),
    Quote(quote: "If at first an idea isn't absurd there is no hope for it", author: "Albert Einstein"),
    Quote(quote: "Imagination is more important than knowledge", author: "Albert Einstein"),
    Quote(quote: "In the middle of difficulty lies opportunity", author: "Albert Einstein"),
    Quote(quote: "There are only two ways to live your life. One is though nothing is a miracle. The other is though everything is a miracle", author: "Albert Einstein"),
    Quote(quote: "When everything seems like an uphill struggle, just think of the view from the top", author: "Unknown"),
    Quote(quote: "Your altitude is determined by your attitude", author: "Unknown"),
    Quote(quote: "What you become is more important than what you accomplish", author: "Unknown"),
    Quote(quote: "No individual raindrop considers itself responsible for the flood", author: "Unknown"),
    Quote(quote: "Man is what he believes", author: "Unknown"),
    Quote(quote: "No one's happiness but my own is in my power to achieve or to destroy.", author: "Ayn Rand"),
    Quote(quote: "The desire not to be anything is the desire not to be", author: "Ayn Rand"),
    Quote(quote: "Well done is better than well said", author: "Benjamin Franklin"),
    Quote(quote: "Success is to be measured not so much by the position that one has reached in life, as by the obstacles one has overcome trying to succeed.", author: "Booker T. Washington"),
    Quote(quote: "We are what we think.", author: "Buddha"),
    Quote(quote: "Better to light one small candle than to curse the darkness.", author: "Chinese Proverb"),
    Quote(quote: "It's the constant and determined effort that breaks down all resistance, sweeps away all obstacles.", author: "Claude M. Bristol"),
    Quote(quote: "Remember, today is the tomorrow you worried about yesterday.", author: "Dale Carnegie")
]
*/
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