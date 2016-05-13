//
//  ViewController.swift
//  FilterViewTest
//
//  Created by David Morrison on 03/03/2016.
//  Copyright © 2016 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let filterId = 1
    
    let cellIdentifier = "Cell"
    
    var tableView: UITableView  =   UITableView()
    
    // listeners
    var listeners = [FilterViewListener]()
    
    // model
    var categories = [String]()
    var activeCategories = Set<String>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        setup()
    }
    
    func setup() {
        // query realm for all the group names to use as the categories
        do {
            let realm = try Realm()
            let groups = realm.objects(Group)
            categories = groups.map({$0.name})
            loadActiveCategories(realm)
        } catch {
            print("Error querying Realm in FilterViewController.")
        }
    }
    
    func loadActiveCategories(realm: Realm) {
        let filter = realm.objects(Filter).filter("id = \(filterId)")
        if filter.count > 0 {
            if let groups = filter.first?.groups.componentsSeparatedByString(", ") {
                activeCategories = Set(groups)
            }
        } else {
            activeCategories = Set(categories)
            saveActiveCategories()
        }
    }
    
    func saveActiveCategories() {
        do {
            let realm = try Realm()
            let filter = Filter()
            filter.groups = activeCategories.joinWithSeparator(", ")
            try! realm.write {
                realm.add(filter, update: true)
            }
        } catch {
            print("Error querying Realm in FilterViewController.")
        }
    }
    
    override func viewDidLoad() {
        let tableHeight = 44 * CGFloat(categories.count)
        let frame = CGRect(origin: view.frame.origin,
            size: CGSize(width: view.frame.size.width, height: tableHeight))
        self.view.frame = frame
        
        tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
        super.viewDidLoad()
    }
    
    func addListener(listener: FilterViewListener) {
        // make sure that listeners can only be added once.
        if !listeners.contains({ (fvl:FilterViewListener) -> Bool in
            return fvl === listener
        }) {
            listeners.append(listener)
        }
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return categories.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
        let switchControl = UISwitch()
        let isOn = activeCategories.contains(category)
        switchControl.setOn(isOn, animated: false)
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(FilterViewController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = switchControl
        
        return cell
    }
    
    func stateChanged(switchState: UISwitch)  {
        if switchState.on {
            activeCategories.insert(categories[switchState.tag])
        } else {
            activeCategories.remove(categories[switchState.tag])
        }
        for listener in listeners {
            listener.filterSelectionHasChanged(activeCategories)
        }
        print(activeCategories)
        saveActiveCategories()
    }
}

protocol FilterViewListener : class {
    func filterSelectionHasChanged(selected: Set<String>)
}