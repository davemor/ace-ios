//
//  MindfulnessViewController.swift
//  ACE
//
//  Created by David Morrison on 23/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var stepBody: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentStep = 0
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    @IBAction func next(sender: UIButton) {
        if currentStep == exercise!.steps.count - 1 {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            currentStep += 1
            refreshView()
        }
    }
    
    func refreshView() {
        stepName.text = exercise?.steps[currentStep].name
        stepBody.text = exercise?.steps[currentStep].description
        if currentStep == exercise!.steps.count - 1 {
            // it's the last step
            nextButton.setTitle("I'm finished!", forState: .Normal)
        } else {
            nextButton.setTitle("Go to step \(currentStep + 2)", forState: .Normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
