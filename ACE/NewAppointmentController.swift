//
//  NewAppointmentController.swift
//  ARC
//
//  Created by David Morrison on 03/12/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import Foundation
import Eureka
import RealmSwift

class NewAppointmentController : FormViewController {
    
    // let appointment = AppointmentActivity()
    var appointmentTitle = ""
    var dateTime = NSDate()
    var address = ""
    var city = ""
    var postcode = ""
    var notes = ""
    
    let dateTimeComponents = NSDateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        // set the components of the datetime to now
        let now = NSDate()
        self.dateTimeComponents.year = now.year
        self.dateTimeComponents.month = now.month
        self.dateTimeComponents.day = now.day()
        self.dateTimeComponents.hour = now.hour()
        self.dateTimeComponents.minute = now.minute()
        
        let b = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(NewAppointmentController.save))
        self.navigationItem.rightBarButtonItem = b
        
        form +++ Section("New Appointment")
            <<< TextRow() { $0.title = "Name"; $0.placeholder = "Name of event" }
                .onChange({ (row) -> () in
                    if let val = row.value {
                        self.appointmentTitle = val
                    }
                })
            <<< DateInlineRow() { $0.title = "Date"; $0.value = NSDate() }
                .onChange({ (row) -> () in
                    self.dateTimeComponents.year = (row.value?.year)!
                    self.dateTimeComponents.month = (row.value?.month)!
                    self.dateTimeComponents.day = (row.value?.day())!
                })
            
            <<< TimeInlineRow(){ $0.title = "Time"; $0.value = NSDate() }
                .onChange({ (row) -> () in
                    self.dateTimeComponents.hour = (row.value?.hour())!
                    self.dateTimeComponents.minute = (row.value?.minute())!
                })
        +++ Section("Address")
            <<< TextAreaRow("Address") { $0.placeholder = "" }
                .onChange({ (row) -> () in
                    if let val = row.value {
                        self.address = val
                    }
                })
            <<< TextRow() { $0.title = "City"; $0.placeholder = "" }
                .onChange({ (row) -> () in
                    if let val = row.value {
                        self.city = val
                    }
                })
            <<< TextRow() { $0.title = "Postcode"; $0.placeholder = "" }
                .onChange({ (row) -> () in
                    if let val = row.value {
                        self.postcode = val
                    }
                })
        +++ Section("Notes")
            <<< TextAreaRow("Notes") { $0.placeholder = "" }
                .onChange({ (row) -> () in
                    if let val = row.value {
                        self.notes = val
                    }
                })
    }
    
    func save() {
        // parse the date
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let date = calendar?.dateFromComponents(dateTimeComponents)
        
        // auto-incroment the appointment id
        do {
            let realm = try Realm()
            try realm.write {
                let appointment = AppointmentActivity()
                
                appointment.id = NSUUID().UUIDString
                appointment.title = appointmentTitle
                appointment.dateTime = date!
                appointment.address = address
                appointment.city = city
                appointment.postcode = postcode
                appointment.notes = notes
                
                realm.add(appointment)
            }
            
            // show an alert
            let alert = UIAlertController(title: "Added", message: "The appointment has been added to your calendar.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        } catch {
            print("Error adding appointment activity to  Realm")
        }
    }
}
