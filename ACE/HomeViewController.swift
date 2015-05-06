//
//  HomeViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var daysInRecoveryView: UILabel!
    @IBOutlet weak var meetingsAttendedView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load up the model
        Model.sharedInstance.downloadSupportDirectory()
        
        // set up the view
        refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        refreshView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshView() {
        // set up the view
        let defaults = NSUserDefaults.standardUserDefaults()
        daysInRecoveryView.hidden = !defaults.boolForKey("show_days_in_recovery")
        meetingsAttendedView.hidden = !defaults.boolForKey("show_days_in_recovery")
    }
}
