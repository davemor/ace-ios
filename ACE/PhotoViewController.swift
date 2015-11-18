//
//  PhotoViewController.swift
//  ACE
//
//  Created by David Morrison on 10/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func replace(sender: AnyObject) {
        getPhoto()
    }
    
    func refresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let filePath = defaults.objectForKey("user_picture") as? String,
           let image = UIImage(contentsOfFile: documentPath(filePath)) {
            imageView.image = image
        } else {
            // there is no picture
            // put in a default
        }

    }
    
    // MARK: Photo picking
    func getPhoto() {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            let alert = UIAlertController(title: "Unsupported", message: "This device does not have a camera", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                let imagePicker: UIImagePickerController = UIImagePickerController();
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = true;
                imagePicker.delegate = self;
                
                self.presentViewController(imagePicker, animated: true, completion: nil);
            });
        }
    }

    // MARK - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // save the image to the local documents folder
        let imageFileName = generateUniqueFileName()
        let fullPath = makePathForImage(imageFileName)
        saveAsPNG(image, fullPath: fullPath)
        
        if picker.sourceType == .Camera {
            // if the image was taken with the camera
            // backup the image to the device image library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
            
        // write the file type to the user preferences
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(imageFileName, forKey: "user_picture")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // refresh the view
        imageView.image = image
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helpers
    func generateUniqueFileName() -> String {
        // create a unique file name for the image
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss-SSS" // ms for a unique filename
        let now = NSDate()
        let dateStr = dateFormatter.stringFromDate(now)
        let randomStr = String(arc4random_uniform(256)) // and a random number
        let fileName = dateStr + randomStr
        return fileName
    }
    func makePathForImage(fileName: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = paths[0] 
        let fullPath = (documentsPath as NSString).stringByAppendingPathComponent(fileName) + ".png"
        return fullPath
    }
    func saveAsPNG(image: UIImage, fullPath: String) {
        // save the image to our local directory so the app can get it back
        if let pngData = UIImagePNGRepresentation(image) {
            pngData.writeToFile(fullPath, atomically: true)
        } else {
            print("Error writing PNG to file in PhotoViewController.")
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
