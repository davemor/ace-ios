//
//  MeetingsTabbar.swift
//  ARC
//
//  Created by David Morrison on 13/05/2016.
//  Copyright © 2016 David Morrison. All rights reserved.
//

import Foundation

class MeetingsTabbar : UITabBarController {
    var filterViewController: FilterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterViewController = FilterViewController()
    }
}