//
//  AppInfoController.swift
//  ARCE
//
//  Created by David Morrison on 15/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class AppInfoController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set up the webview
        self.webView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        let htmlFile = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("about", ofType: "html")!)!
        webView.loadRequest(NSURLRequest(URL: htmlFile))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Webview Delegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
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
