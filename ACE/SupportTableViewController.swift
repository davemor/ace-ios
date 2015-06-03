//
//  SupportTableViewController.swift
//  ACE
//
//  Created by David Morrison on 22/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class SupportTableViewController: UITableViewController {

    let services = Realm().objects(Service)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("supportListReuseId", forIndexPath: indexPath) as! UITableViewCell

        let service = serviceAtPath(indexPath)
        cell.textLabel?.text = service.name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showSupportDetailsSegue", sender: indexPath)
    }

    func serviceAtPath(path: NSIndexPath) -> Service {
        return services[path.row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showSupportDetailsSegue" {
            if let indexPath = sender as? NSIndexPath {
                if let dest = segue.destinationViewController as? ServiceDetailViewController {
                    let service = serviceAtPath(indexPath)
                    dest.service = service
                }
            }
        }
    }
}
