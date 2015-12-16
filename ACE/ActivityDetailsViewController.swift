//
//  ActivityDetailsViewController.swift
//  ACE
//
//  Created by David Morrison on 26/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class ActivityDetailsViewController: UITableViewController, MKMapViewDelegate {

    // MARK: - Model
    var activity: Activity!
    
    // MARK: - Outlets
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var whenView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var descriptionView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = activity.name
        refreshAddButtonTitle()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // set when
        whenView.text = getActivityDateRangeString(activity)
        
        // set where
        if let venue = activity.venue {
            let addressParts = venue.address.characters.split { $0 == "," }.map { String($0) }.map { $0.trimmed() }
            let address = addressParts.joinWithSeparator(",\n")
            addressView.text = address
        } else {
            // TODO: This is a hack
            // try and downcast the activity to an AppointmentActivity
            if let appointmentActivity = activity as? AppointmentActivity {
                addressView.text = "\(appointmentActivity.address)\n\(appointmentActivity.city)\n\(appointmentActivity.postcode)"
            }
        }
        
        // set description
        descriptionView.text = activity.desc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    func refreshAddButtonTitle() {
        // print(self.activity.attending)
        let title = activity.attending ? "Remove" : "Add"
        addButton.title = title
    }
    
    // MARK: - TableView
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Actions
    @IBAction func toggleAttending(sender: AnyObject) {
        do {
            let realm = try Realm()
            try realm.write {
                self.activity.attending = !self.activity.attending
            }
            refreshAddButtonTitle()
        } catch {
            print("Error toggling attending in ActivityDetailsViewController.")
        }
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        let placemark = MKPlacemark(coordinate: activity.venue!.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = activity.name
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    @IBAction func openOnWeb(sender: AnyObject) {
        if let str = activity.url {
            if let url = NSURL(string: str) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                // TODO: Show alert
            }
        }
    }
    
    
    // MARK: - Map View
    let reuseId = "annotationViewReuseId"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view!.canShowCallout = true
            view!.image = UIImage(named: "BlueMapPin")!
        }
        
        // configure the annotation
        view!.annotation = annotation
        return view
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

func getActivityDateRangeString(activity: Activity) -> String {
    if onSameDay(activity.start, date1: activity.end) {
        let dayOfWeek = activity.start.toString(format: DateFormat.Custom("EEEE"))
        let day = activity.start.toString(format: DateFormat.Custom("dd"))
        let suffix = daySuffix(activity.start)
        let month = activity.start.toString(format: DateFormat.Custom("MMMM"))
        let start = activity.start.toString(format: DateFormat.Custom("HH:mm"))
        let end = activity.end.toString(format: DateFormat.Custom("HH:mm"))
        return "\(dayOfWeek) \(day)\(suffix) of \(month)\nFrom\t\(start)\nUntil\t\(end)"
    } else {
        let start = activity.start.toString()
        let end = activity.end.toString()
        return "From \(start) to \(end)"
    }
}

func daySuffix(date: NSDate) -> String {
    let calendar = NSCalendar.currentCalendar()
    let dayOfMonth = calendar.component(.Day, fromDate: date)
    switch dayOfMonth {
    case 1: fallthrough
    case 21: fallthrough
    case 31: return "st"
    case 2: fallthrough
    case 22: return "nd"
    case 3: fallthrough
    case 23: return "rd"
    default: return "th"
    }
}

func onSameDay(date0: NSDate, date1: NSDate) -> Bool {
    let cal = NSCalendar.currentCalendar()
    var components = cal.components(([.Era, .Year, .Month, .Day]), fromDate:date0)
    let firstDate = cal.dateFromComponents(components)!
    
    components = cal.components(([.Era, .Year, .Month, .Day]), fromDate:date1);
    let otherDate = cal.dateFromComponents(components)!
    
    return firstDate.isEqualToDate(otherDate)
}

class ActivityAnnotation: NSObject, MKAnnotation {
    let myCoordinate: CLLocationCoordinate2D
    let myTitle: String
    
    init(activity: Activity) {
        self.myCoordinate = activity.venue!.coordinate
        self.myTitle = activity.name
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
    
    // Title and subtitle for use by selection UI.
    var title: String? {
        return myTitle
    }
}
