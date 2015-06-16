//
//  HomeViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //@IBOutlet weak var daysInRecoveryView: UILabel!
    //@IBOutlet weak var meetingsAttendedView: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var pictureView: HaxagonWithImage!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load up the model
        // Model.sharedInstance.deleteAll()
        Model.sharedInstance.updateFromServer()
        Model.sharedInstance.updateFromCommunityCalendar()
        
        // style the controls
        setupStyles()
        
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
        
        refreshView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    
        //UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
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
        if let filePath = defaults.objectForKey("user_picture") as? String,
            let image = UIImage(contentsOfFile: filePath) {
                pictureView.image = image
        }
        
        /*
        // set up the view
        let defaults = NSUserDetfaults.standardUserDefaults()
        daysInRecoveryView.hidden = !defaults.boolForKey("show_days_in_recovery")
        meetingsAttendedView.hidden = !defaults.boolForKey("show_days_in_recovery")
        
        // set the values of the view
        if let dateStr = defaults.stringForKey("recovery_start_date") {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            if let date = dateFormatter.dateFromString(dateStr) {
                daysInRecoveryView.text = "Days \(daysBetweenDates(date, NSDate()))"
            } else {
                daysInRecoveryView.text = "Days 0"
            }
        } else {
            daysInRecoveryView.text = "Days 0"
        }
        */
    }
}
