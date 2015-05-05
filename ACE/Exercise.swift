//
//  File.swift
//  ACE
//
//  Created by David Morrison on 23/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

/*
Title – One Minute breathing
SCREEN 1 -  Start by breathing in and out slowly, holding your breath for a count of six once you’ve inhaled. Then breathe out slowly, letting the breath flow effortlessly
SCREEN 2 - watch your breath with your senses as it enters your body and fills you with life, and then watch it work its way up and out of your body as the energy dissipates into the universe

Title – Mindful Observation
SCREEN 1 - Pick a natural organism within your immediate environment and focus on watching it for a minute or two. This could be a flower or an insect, the clouds or the moon.
SCREEN2-   Don’t do anything except notice the thing you are looking at. But really notice it. Look at it as if you are seeing it for the first time.

Title – Touch Points
Screen 1  - Think of something that happens every day more than once, something you take for granted, like opening a door for example.
SCREEN2 - At the very moment you touch the door knob to open the door, allow yourself to be completely mindful of where you are, how you feel and what you are doing.
Try doing this with non physical cues, for example negative thoughts or smelling food.
*/

import Foundation

struct Exercise {
    let name: String
    let steps:[Step]
    
    struct Step {
        let name: String
        let description: String
    }
    
    static var all:[Exercise] = [
        Exercise(name: "One Minute breathing", steps: [
                Step(name: "Step 1", description: "Start by breathing in and out slowly, holding your breath for a count of six once you’ve inhaled. Then breathe out slowly, letting the breath flow effortlessly."),
                Step(name: "Step 2", description: "Watch your breath with your senses as it enters your body and fills you with life, and then watch it work its way up and out of your body as the energy dissipates into the universe.")
        ]),

        Exercise(name: "Mindful Observation", steps: [
            Step(name: "Step 1", description: "Pick a natural organism within your immediate environment and focus on watching it for a minute or two. This could be a flower or an insect, the clouds or the moon."),
            Step(name: "Step 2", description: "Don’t do anything except notice the thing you are looking at. But really notice it. Look at it as if you are seeing it for the first time."),
        ]),
        
        Exercise(name: "Touch Points", steps: [
            Step(name: "Step 1", description: "Think of something that happens every day more than once, something you take for granted, like opening a door for example."),
            Step(name: "Step 2", description: "At the very moment you touch the door knob to open the door, allow yourself to be completely mindful of where you are, how you feel and what you are doing.\nTry doing this with non physical cues, for example negative thoughts or smelling food.")
        ])
    ]
}







