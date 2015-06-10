//
//  Style.swift
//  ACE
//
//  Created by David Morrison on 09/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

func setupStyles() {
    // UIButton.appearance().backgroundColor = UIColor.blueColor()
    // UIButton.appearance().setTitleColor(UIColor.whiteColor(), forState: .Normal)
    UILabel.appearance().font = UIFont(name: "AvenirNext-Regular", size: 16)
    
    // style the navigation bar
    UINavigationBar.appearance().titleTextAttributes = [
        NSString(string: NSFontAttributeName): UIFont(name: "Arial Rounded MT Bold", size: 16)!
    ]
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    // status bar
    UIApplication.sharedApplication().setStatusBarStyle(
        UIStatusBarStyle.LightContent, animated: false)
}