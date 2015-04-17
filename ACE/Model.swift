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
    
    let baseURI = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")
    
    // load support directory from file
    func loadSupportDirectory(filename:String) {
        // load the NSData
        // refreash the model from the data
    }
    
    // download a new JSON file from the server
    func downloadSupportDirectory() {
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseURI!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
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
            
            // TODO: Could we generalise this?
            
            // read in the groups
            if let groupsArray = dict["groups"] as? NSArray {
                loadGroups(groupsArray)
            } else {
                println("Error: Groups array is missing from the model JSON object.")
            }
            
            // read in the venues
            if let venuesArray = dict["venues"] as? NSArray {
                loadVenues(venuesArray)
            } else {
                println("Error: Venues array is missing from the model JSON object.")
            }

            // read in the services
            if let servicesArray = dict["services"] as? NSArray {
                loadServices(servicesArray)
            } else {
                println("Error: Services array is missing from the model JSON object.")
            }
            
            // read in the events
            if let eventsArray = dict["events"] as? NSArray {
                loadEvents(eventsArray)
            } else {
                println("Error: Events array is missing from the model JSON object.")
            }
            
        } else {
            println("Error: could not parse model JSON.")
        }
        println(venues)
    }
    
    // helper functions for deserializing the model from property list
    func loadVenues(arr:NSArray) {
        // Load all the venues into a dict where the key is the id of the venue.
        // This will allow all of the things that use it to query easily.
        for dict in arr {
            let venue = Venue(dict: dict as! NSDictionary)
            venues[venue.id] = venue
        }
    }
    func loadGroups(groupsArray:NSArray) {
    }
    func loadServices(servicesArray:NSArray) {
    }
    func loadEvents(eventsArray:NSArray) {
    }
    
    // Tables for the elements of the service directory
    var venues = [Int:Venue]()
}










