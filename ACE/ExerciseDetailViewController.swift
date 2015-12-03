//
//  MindfulnessViewController.swift
//  ACE
//
//  Created by David Morrison on 23/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ExerciseDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the webview
        self.webview.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        let htmlFile = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("mindfulness", ofType: "html")!)
        webview.loadRequest(NSURLRequest(URL: htmlFile))
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
}

