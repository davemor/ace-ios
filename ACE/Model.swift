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
    
    // let serverBaseUrl = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")!
    // let serverBaseUrl = NSURL(string: "http://localhost:3000/api/")!
    // let serverBaseUrl = NSURL(string: "http://arc.cechosting.org/api/")!
    // let serverBaseUrl = NSURL(string: "http://edinburgharcapp.co.uk/api")!
    let serverBaseUrl = NSURL(string: "http://edinburgh.arcapp.co.uk/api")!
    
    let communityCalendarUrl = NSURL(string: "https://recoverycommunitycalendar.hasacalendar.co.uk/api1/events.json")!
    
    func deleteAll() {
        do {
            let realm = try Realm()
            try Realm().write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting realm.")
        }
    }
    
    func updateFromServer() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if let response = NSData(contentsOfURL: self.serverBaseUrl) {
                
                do {
                
                // De-serialize the response to JSON
                let json = (try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions(rawValue: 0))) as! NSDictionary
                
                //if let filePath = NSBundle.mainBundle().pathForResource("test_data", ofType: "json"), data = NSData(contentsOfFile: filePath) {
                    //do {
                        //let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        
                        do {
                            
                            let realm = try Realm()
                            
                            // in order to deal with elements that might have been deleted
                            // we will clear the realm of events, services, groups etc
                            /*
                             try realm.write {
                             realm.delete(realm.objects(Meeting))
                             realm.delete(realm.objects(Venue))
                             realm.delete(realm.objects(Group))
                             realm.delete(realm.objects(Service))
                             }
                             */
                            
                            // get the id's of all the object that exist in the database
                            
                            var newVenueIds = [Int]()
                            var newGroupIds = [Int]()
                            var newMeetingIds = [Int]()
                            var newServiceIds = [Int]()
                            
                            try realm.write {
                                // read in the venues
                                if let venues = json["venues"] as? NSArray {
                                    for dict in venues {
                                        if let dict = dict as? NSDictionary {
                                            let venue = Venue()
                                            venue.id = dict.read("id", alt: 0)
                                            venue.name = dict.read("name", alt: "")
                                            venue.address = dict.read("address", alt: "")
                                            venue.city = dict.read("city", alt: "")
                                            venue.postcode = dict.read("postcode", alt: "")
                                            venue.email = dict.read("email", alt: "")
                                            venue.telephone = dict.read("telephone", alt: "")
                                            venue.website = dict.read("website", alt: "")
                                            venue.latitude = dict.read("latitude", alt: 0.0)
                                            venue.longitude = dict.read("longitude", alt: 0.0)
                                            realm.add(venue, update:true)
                                            newVenueIds.append(venue.id)
                                        }
                                    }
                                }
                            }
                            
                            try realm.write {
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
                                            // println(group)
                                            realm.add(group, update:true)
                                            newGroupIds.append(group.id)
                                        }
                                    }
                                }
                            }
                            try realm.write {
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
                                            meeting.`repeat` = Repeat.strToRaw(dict.read("repeat", alt: "none"))
                                            meeting.day = Day.strToRaw(dict.read("day_of_week", alt: "none"))
                                            
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
                                                // print(first!.name)
                                                meeting.group = first!
                                            }
                                            
                                            // add the meeting to the realm.
                                            realm.add(meeting, update: true)
                                            newMeetingIds.append(meeting.id)
                                        }
                                    }
                                }
                            }
                            try realm.write {
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
                                                    if let t = time as? NSDictionary {
                                                        let bt = BusinessTime()
                                                        bt.open = t.readDateTime("opening_time")
                                                        bt.close = t.readDateTime("closing_time")
                                                        bt.monday = t.read("monday", alt: false)
                                                        bt.tuesday = t.read("tuesday", alt: false)
                                                        bt.wednesday = t.read("wednesday", alt: false)
                                                        bt.thursday = t.read("thursday", alt: false)
                                                        bt.friday = t.read("friday", alt: false)
                                                        bt.saturday = t.read("saturday", alt: false)
                                                        bt.sunday = t.read("sunday", alt: false)
                                                        service.businessTimes.append(bt)
                                                    }
                                                }
                                            }
                                            
                                            realm.add(service, update: true)
                                            newServiceIds.append(service.id)
                                        }
                                    }
                                }
                                
                            }
                            
                            // remove anything from the local database that is not present on the server
                            // the records that are present on the server, will have their id's present in the lists
                            
                            // remove old services
                            let ss = realm.objects(Service)
                            let oldServices = List<Service>()
                            for s in ss {
                                if !newServiceIds.contains(s.id) {
                                    oldServices.append(s)
                                }
                            }
                            if oldServices.count > 0 {
                                try realm.write {
                                    realm.delete(oldServices)
                                }
                            }

                            // remove old meetings
                            let ms = realm.objects(Meeting)
                            let oldMeetings = List<Meeting>()
                            for m in ms {
                                if !newMeetingIds.contains(m.id) {
                                    oldMeetings.append(m)
                                }
                            }
                            if oldMeetings.count > 0 {
                                try realm.write {
                                    realm.delete(oldMeetings)
                                }
                            }
                            
                            // remove old groups
                            let gs = realm.objects(Group)
                            let oldGroups = List<Group>()
                            for g in gs {
                                if !newGroupIds.contains(g.id) {
                                    oldGroups.append(g)
                                }
                            }
                            if oldGroups.count > 0 {
                                try realm.write {
                                    realm.delete(oldGroups)
                                }
                            }
                            
                            // remove old venues
                            let vs = realm.objects(Venue)
                            let oldVenues = List<Venue>()
                            for v in vs {
                                if !newVenueIds.contains(v.id) {
                                    oldVenues.append(v)
                                }
                            }
                            if oldVenues.count > 0 {
                                try realm.write {
                                    realm.delete(oldVenues)
                                }
                            }
                            
                            // remove any orphened calendar activities
                            // ie ones where the meeting has just been deleted
                             let orphenedMeetings = realm.objects(MeetingActivity).filter("meeting = nil")
                             if orphenedMeetings.count > 0 {
                                 try realm.write {
                                    // print("DELETING")
                                    // print(orphenedMeetings)
                                    realm.delete(orphenedMeetings)
                                 }
                             }
                            
                        } catch {
                            print("Error writting to Realm.")
                        }

                    //}
                    //catch {
                        //Handle error
                    //}
                //}
                
                } catch {
                    print("Error parsing the server JSON into NSDictionary.")
                }
                
            } else {
                // TODO: Try again later.
                print("Cannot Reach server")
            }
        }
    }
    
    func queryFromIds(ids: [Int]) -> String {
        var query = ""
        var sep = ""
        for id in ids {
            query.appendContentsOf(sep + "id != \(id)")
            sep = " AND "
        }
        // print(query)
        return query
    }
    
    func updateFromCommunityCalendar() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if let response = NSData(contentsOfURL: self.communityCalendarUrl) {
                
                // De-serialize the response to JSON
                let json = (try! NSJSONSerialization.JSONObjectWithData(response,
                    options: NSJSONReadingOptions(rawValue: 0))) as! NSDictionary
                
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        if let events = json["data"] as? NSArray {
                            for data in events {
                                if let event = data as? NSDictionary {
                                    //print(event, terminator: "")
                                    
                                    let activity = CommunityActivity()
                                    activity.slug = event.read("slug", alt: 0)
                                    activity.summary = event.read("summary", alt: "")
                                    activity.aDescription = event.read("description", alt: "")
                                    if let start = event["start"] as? NSDictionary {
                                        activity.startDate = start.readTimeStamp("timestamp")
                                    }
                                    if let end = event["end"] as? NSDictionary {
                                        activity.endDate = end.readTimeStamp("timestamp")
                                    }
                                    activity.aURL = event.read("url", alt: "")
                                    if let venue = event["venue"] as? NSDictionary {
                                        let v = Venue()
                                        v.id = venue.read("slug", alt: 0)
                                        v.name = venue.read("title", alt: "")
                                        v.address = venue.read("address", alt: "")
                                        //print(v.address, terminator: "")
                                        // v.city = this is missing or rather part of the address.
                                        v.postcode = venue.read("addresscode", alt: "")
                                        v.latitude = venue.read("lat", alt: 0.0)
                                        v.longitude = venue.read("lng", alt: 0.0)
                                        realm.add(v, update: true)
                                        activity.aVenue = v
                                    }
                                    activity.deleted = event.read("deleted", alt: false)
                                    activity.cancelled = event.read("cancelled", alt: false)
                                    
                                    //print(activity, terminator: "")
                                    realm.add(activity, update: true)
                                    
                                    // println(activity)
                                }
                            }
                        }
                    }
                    
                    // remove any orphened calendar activities
                    let orphenedCommunityActivities = realm.objects(CommunityActivity).filter("deleted == true OR cancelled == true")
                    try realm.write {
                        realm.delete(orphenedCommunityActivities)
                    }
                    
                } catch {
                    print("Error writting community calendar to Realm.")
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
            let formatter = NSDateFormatter()
            let format = format
            formatter.dateFormat = format
            if let date = formatter.dateFromString(str) {
                rtn = date
            }
        }
        return rtn
    }
    func readTimeStamp(key: String) -> NSDate {
        var rtn = NSDate(timeIntervalSince1970: 0)
        if let stamp = objectForKey(key) as? Int {
            rtn = NSDate(timeIntervalSince1970: NSTimeInterval(stamp))
        }
        return rtn
    }
}
