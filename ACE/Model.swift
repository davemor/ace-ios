//
//  Model.swift
//  ACE
//
//  Created by David Morrison on 16/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

// Model is a singleton that manages access to all the data in the app.
// Responsible for loading it from a source and caching.
class Model {
    // shared singleton instance
    class var sharedInstance: Model {
        struct Static {
            static var instance: Model?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Model()
        }
        
        return Static.instance!
    }
    
    // let baseUrl = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")
    let baseUrl = NSURL(string: "http://localhost:3000/api/")
    
    // load support directory from file
    func loadSupportDirectory(filename:String) {
        // load the NSData
        // refreash the model from the data
    }
    
    // download a new JSON file from the server
    func downloadSupportDirectory() {
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseUrl!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            println(location)
            if (error == nil) {
                if let dataObject = NSData(contentsOfURL: location) {
                    self.refreashSupportDirectoryModel(dataObject)
                    
                    // save the model somewhere
                }
            } else {
                
            }
        })
        downloadTask.resume()
    }
    
    // refreash support directory model from NSData
    func refreashSupportDirectoryModel(dataObject: NSData) {
        // deserialise the JSON object
        if let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as? NSDictionary {
            // read in the groups
            readArray("groups", dict, loadGroups)
            readArray("venues", dict, loadVenues)
            readArray("services", dict, loadServices)
            readArray("events", dict, loadEvents)
        } else {
            println("Error: could not parse model JSON.")
        }
        println(Venue.all)
        println(Service.all)
        println(Group.all)
        println(Event.all)
    }
    
    // helper functions for deserializing the model from property list
    func loadVenues(arr:NSArray) {
        for dict in arr {
            let venue = Venue(dict: dict as! NSDictionary)
            Venue.all[venue.id] = venue
        }
    }
    func loadGroups(arr:NSArray) {
        for dict in arr {
            let group = Group(dict: dict as! NSDictionary)
            Group.all[group.id] = group
        }
    }
    func loadServices(arr:NSArray) {
        for dict in arr {
            let service = Service(dict: dict as! NSDictionary)
            Service.all[service.id] = service
        }
    }
    func loadEvents(arr:NSArray) {
        for dict in arr {
            let event = Event(dict: dict as! NSDictionary)
            Event.all[event.id] = event
        }
    }
}

// some helper function for reading property lists in Swift

func readArray(key:String, dict:NSDictionary, handler: (arr:NSArray) -> () ) {
    if let array = dict[key] as? NSArray {
        handler(arr: array)
    } else {
        println("Error: \(key) array is missing from JSON object.")
    }
}

func read<T>(key:String, dict:NSDictionary, alt:T) -> T {
    if let obj = dict.objectForKey(key) as? T {
        return obj
    } else {
        return alt
    }
}

func readDate(key:String, dict:NSDictionary) -> NSDate {
    var rtn = NSDate()
    if let str = dict.objectForKey(key) as? String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        if let date = formatter.dateFromString(str) {
            rtn = date
        }
    }
    return rtn
}








