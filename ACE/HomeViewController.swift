//
//  HomeViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import Mixpanel

class HomeViewController: UIViewController {

    //@IBOutlet weak var daysInRecoveryView: UILabel!
    //@IBOutlet weak var meetingsAttendedView: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var pictureView: HaxagonWithImage!
    
    
    @IBOutlet weak var daysHexagon: HexagonView!
    @IBOutlet weak var daysCounterLabel: UILabel!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load up the model
        // Model.sharedInstance.deleteAll()
        // Model.sharedInstance.updateFromServer()
        // Model.sharedInstance.updateFromCommunityCalendar()
        
        // style the controls
        setupStyles()
        
        daysCounterLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 36)
        
        // set up the view
        refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        // UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)

        // this should be done quite a bit so to keep the data fresh
        Model.sharedInstance.updateFromServer()
        Model.sharedInstance.updateFromCommunityCalendar()
        
        refreshView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    
        //UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    }
    
    // MARK: - Actions
    @IBAction func sendFeedback(sender: AnyObject) {
        // log with analytics
        Mixpanel.sharedInstance().track("Tapped on Feedback Icon")
        
        let url = NSURL(string: "mailto:addicationrecoverycompanion@gmail.com?subject=Feedback%20from%20iOS%20App")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    //override func prefersStatusBarHidden() -> Bool {
    //    return true
    //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshView() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let imagePath = defaults.objectForKey("user_picture") as? String,
            let image = UIImage(contentsOfFile: documentPath(imagePath)) {
                pictureView.image = image
                pictureView.setNeedsDisplay()
        }
        
        // set up the view
        daysHexagon.hidden = !defaults.boolForKey("show_days_in_recovery")
        
        // set the values of the view
        daysCounterLabel.text = "0"
        if let dateStr = defaults.stringForKey("recovery_start_date") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            if let date = dateFormatter.dateFromString(dateStr) {
                daysCounterLabel.text = "\(daysBetweenDates(date, endDate: NSDate()))"
            }
        }
    }
}
