//
//  File.swift
//  ACE
//
//  Created by David Morrison on 23/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Exercise {
    let name: String
    let steps:[Step]
    
    struct Step {
        let name: String
        let description: String
    }
    
    static var all:[Exercise] = [
        Exercise(name: "Simple Exercise", steps: [
                Step(name: "Step 1", description: "Description of step 1"),
                Step(name: "Step 2", description: "Description of step 2")
        ])
    ]
}