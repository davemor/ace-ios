//
//  NewDiaryEntryViewController.swift
//  ARC
//
//  Created by David Morrison on 16/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class NewDiaryEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addPhotoButtonHeightConstraint: NSLayoutConstraint!
    
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = NSDate().toString(format: DateFormat.Custom("dd/MM/YY"))
        
        textArea.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func save(sender: AnyObject) {
        do {
            let realm = try Realm()
            try realm.write {
                let entry = DiaryEntry()
                entry.text = self.textArea.text
                if let path = self.imagePath {
                    entry.imagePath = path
                    entry.hasImage = true
                }
                realm.add(entry, update: false)
            }
            let alert = UIAlertController(title: "Entry Added", message: "The entry has been added to your diary.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } catch {
            print("Error saving new diary entry.")
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
    
    // MARK: Photo picking
    
    @IBAction func addPhoto(sender: AnyObject) {
        getPhoto()
        addPhotoButton.hidden = true
        addPhotoButtonHeightConstraint.constant = 0
    }
    
    func getPhoto() {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            let alert = UIAlertController(title: "Unsupported", message: "This device does not have a camera", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated:true, completion:nil)
        }
    }
    
    // MARK - ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // save the image to the local documents folder
        let fullPath = makePathForImage(generateUniqueFileName())
        saveAsPNG(image, fullPath: fullPath)
        
        if picker.sourceType == .Camera {
            // if the image was taken with the camera
            // backup the image to the device image library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        self.imagePath = fullPath
        
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
        let fullPath = documentsPath + "/" + fileName + ".png" // TODO: This might be a source of bugs.
        return fullPath
    }
    func saveAsPNG(image: UIImage, fullPath: String) {
        // save the image to our local directory so the app can get it back
        let pngData = UIImagePNGRepresentation(image);
        pngData!.writeToFile(fullPath, atomically: true)
    }

}
