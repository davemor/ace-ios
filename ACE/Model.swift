//
//  Model.swift
//  ace-model
//
//  Created by David Morrison on 17/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//
//  Provides a set of helper functions for working with
//  the model of the application.

import Foundation
import RealmSwift

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
    
    let serverBaseUrl = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")!
    // let serverBaseUrl = NSURL(string: "http://localhost:3000/api/")!
    
    let communityCalendarUrl = NSURL(string: "https://recoverycommunitycalendar.hasacalendar.co.uk/api1/events.json")!
    
    func deleteAll() {
        let realm = Realm()
        Realm().write {
           realm.0deleteAll()
        }
    }
    
    func updateFromServer() {
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if let response = NSData(contentsOfURL: self.serverBaseUrl) {
                
                // De-serialize the response to JSON
                let json = NSJSONSerialization.JSONObjectWithData(response,
                    options: NSJSONReadingOptions(0),
                    error: nil) as! NSDictionary
                
                let realm = Realm()
                realm.write {
                    // read in the venues
                    if let venues = json["venues"] as? NSArray {
                        for data in venues {
                            realm.create(Venue.self, value: data, update: true)
                        }
                    }
                }
                realm.write {
                    // read in the groups
                    if let groups = json["groups"] as? NSArray {
                        for data in groups {
                            if let dict = data as? NSDictionary {
                                let group = Group()
                                group.id = dict.read("id", alt: 0)
                                group.name = dict.read("name", alt: "")
                                group.desc = dict.read("description", alt: "")
                                group.contactName = dict.read("contact_name", alt: "")
                                group.telephone = dict.read("telephone", alt: "")
                                println(group)
                                realm.add(group, update:true)
                            }
                        }
                    }
                }
                realm.write {
                    // read in the meetings
                    if let meetings = json["events"] as? NSArray {
                        for data in meetings {
                            if let dict = data as? NSDictionary {
                                let meeting = Meeting()
                                meeting.id = dict.read("id", alt: 0)
                                meeting.name = dict.read("name", alt: "")
                                meeting.desc = dict.read("description", alt: "")
                                meeting.contactName = dict.read("contact_name", alt: "")
                                meeting.contactPhone = dict.read("contactPhone", alt: "")
                                meeting.dateTime = dict.readDateTime("date_time")
                                meeting.repeat = Repeat.strToRaw(dict.read("repeat", alt: "none"))
                                meeting.day = Meeting.Day.strToRaw(dict.read("day_of_week", alt: "none"))
                                
                                // find the venue if it exists
                                let venueId = dict.read("venue_id", alt: 0)
                                let venueRes = realm.objects(Venue).filter("id = %d", venueId)
                                if venueRes.count > 0 {
                                    meeting.venue = venueRes.first
                                }
                                
                                // find the group if it exists
                                let groupId = dict.read("group_id", alt: 0)
                                let predicate = NSPredicate(format: "id = %d", groupId)
                                let groupRes = realm.objects(Group).filter(predicate)
                                if groupRes.count > 0 {
                                    let first = groupRes.first
                                    print(first)
                                    meeting.group = first!
                                }
                                
                                // add the meeting to the realm.
                                realm.add(meeting, update: true)
                                print(meeting)
                            }
                        }
                    }
                } /*
                realm.write {
                    // read in the services
                    if let services = json["services"] as? NSArray {
                        for data in services {
                            if let dict = data as? NSDictionary {
                                let service = Service()
                                service.id = dict.read("id", alt: 0)
                                service.name = dict.read("name", alt: "")
                                service.desc = dict.read("description", alt: "")
                                service.telephone = dict.read("telephone", alt: "")
                                service.email = dict.read("email", alt: "")
                                service.mobile = dict.read("mobile", alt: "")
                                service.fax = dict.read("fax", alt: "")
                                service.website = dict.read("website", alt: "")
                                service.supportOptions = dict.read("supportOptions", alt: "")
                                service.referralMethod = dict.read("referralMethod", alt: "")
                                service.recoveryHubs = dict.read("recoveryHubs", alt: "")
                                service.businessTimesExtraInfo = dict.read("businessTimesExtraInfo", alt: "")
                                
                                // find the venue if it exists
                                let venueId = dict.read("venue_id", alt: 0)
                                let venueRes = realm.objects(Venue).filter("id = %d", venueId)
                                if venueRes.count > 0 {
                                    service.venue = venueRes.first
                                }
                                
                                // set up the business hours
                                if let times = dict.objectForKey("business_times") as? NSArray {
                                    for time in times {
                                        let bt = BusinessTime()
                                        bt.open = dict.readDateTime("opening_time")
                                        bt.close = dict.readDateTime("closing_time")
                                        bt.monday = dict.read("monday", alt: false)
                                        bt.tuesday = dict.read("tuesday", alt: false)
                                        bt.wednesday = dict.read("wednesday", alt: false)
                                        bt.thursday = dict.read("thursday", alt: false)
                                        bt.friday = dict.read("friday", alt: false)
                                        bt.saturday = dict.read("saturday", alt: false)
                                        bt.sunday = dict.read("sunday", alt: false)
                                        service.businessTimes.append(bt)
                                    }
                                }
                            }
                        }
                    }
                }
                */
            } else {
                // TODO: Try again later.
                println("Cannot Reach server")
            }
        }
    }

    let rfc2882utcFormat = "ddd, dd MMM yyyy HH:mm:ss K"
    
    func updateFromCommunityCalendar() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if let response = NSData(contentsOfURL: self.communityCalendarUrl) {
                
                // De-serialize the response to JSON
                let json = NSJSONSerialization.JSONObjectWithData(response,
                    options: NSJSONReadingOptions(0),
                    error: nil) as! NSDictionary
                
                let realm = Realm()
                realm.write {
                    if let events = json["data"] as? NSArray {
                        for data in events {
                            if let event = data as? NSDictionary {
                                let activity = CommunityActivity()
                                activity.slug = event.read("slug", alt: 0)
                                activity.summary = event.read("summary", alt: "")
                                activity.aDescription = event.read("description", alt: "")
                                if let start = event["start"] as? NSDictionary {
                                    activity.startDate = start.readDateTime("rfc2882utc", format: self.rfc2882utcFormat)
                                }
                                if let end = event["end"] as? NSDictionary {
                                    activity.endDate = end.readDateTime("rfc2882utc", format: self.rfc2882utcFormat)
                                }
                                activity.aURL = event.read("url", alt: "")
                                if let venue = event["venue"] as? NSDictionary {
                                    let v = Venue()
                                    v.id = venue.read("slug", alt: 0)
                                    v.name = venue.read("title", alt: "")
                                    v.address = venue.read("address", alt: "")
                                    // v.city = this is missing or rather part of the address.
                                    v.postcode = venue.read("addresscode", alt: "")
                                    v.latitude = venue.read("lat", alt: 0.0)
                                    v.longitude = venue.read("lng", alt: 0.0)
                                    activity.aVenue = v
                                }
                                realm.add(activity, update: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension NSDictionary {
    func read<T>(key:String, alt:T) -> T {
        if let obj = objectForKey(key) as? T {
            return obj
        } else {
            return alt
        }
    }
    func readDateTime(key:String, format:String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z") -> NSDate {
        var rtn = NSDate()
        if let str = objectForKey(key) as? String {
            var formatter = NSDateFormatter()
            let format = format
            // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            formatter.dateFormat = format
            if let date = formatter.dateFromString(str) {
                rtn = date
            }
        }
        return rtn
    }
}


















