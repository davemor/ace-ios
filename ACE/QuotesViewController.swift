//
//  QuotesTableView.swift
//  ACE
//
//  Created by David Morrison on 16/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class QuotesViewController: UITableViewController {

    var currentCell:QuotesTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set this a the degates
        tableView.delegate = self
        tableView.dataSource = self
        
        // add refresh control
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.whiteColor()
        let attrs = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        refresh.attributedTitle = NSAttributedString(string: "Pull for a new quote.", attributes:attrs)
        refresh.addTarget(self, action: "refreshView", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        // initialize the view
        changeToNewQuote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - respond to refresh
    
    func refreshView() {
        let attrs = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        refreshControl!.attributedTitle = NSAttributedString(string: "Updating quote.", attributes:attrs)
        self.changeToNewQuote()
        self.changeToRandomColor()
        //refreshControl!.attributedTitle = NSAttributedString(string: "Pull for a new quote.", attributes:attrs)
        refreshControl?.endRefreshing()
    }
    
    func changeToNewQuote() {
        if var target = currentCell {
            // randomly select a new quote
            let numQuotes = UInt32(quotes.count)
            let index = Int(arc4random_uniform(numQuotes))
            let quote = quotes[index]
            
            // bind the cell to it
            currentCell?.quoteText.text = "\"\(quote.quote)\""
            currentCell?.authorText.text = quote.author
        }
    }
    
    func changeToRandomColor() {
        let color = getRandomAceColor()
        currentCell?.backgroundColor = color
        self.tableView.backgroundColor = color
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quotesCellReuseId", forIndexPath: indexPath) 
        currentCell = cell as? QuotesTableViewCell
        return cell
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