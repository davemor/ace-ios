//
//  EventDetailViewController.swift
//  ACE
//
//  Created by David Morrison on 22/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UITableViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var telephoneButton: UIButton!

    var event:Event?
    var venue:Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = event!.displayName
        address.text = venue!.fullAddress
        eventDescription.text = event!.displayDescription
        datetime.text = event!.displayTime
        contactName.text = event!.displayContactName
        telephoneButton.setTitle(event!.displayContactPhone, forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showTelephone(sender: UIButton) {
        let phoneNumber = "tel://\(condenseWhitespace(event!.displayContactPhone))"
        println(phoneNumber)
        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
    }
    
    @IBAction func showDirections(sender: UIButton) {
        let placemark = MKPlacemark(coordinate: venue!.location, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue!.displayName
        mapItem.openInMapsWithLaunchOptions(nil)
    }    
}
