//
//  PictureConfirmViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/1/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class PictureConfirmViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //user presses save button
    @IBAction func saveButtonAction(sender: UIBarButtonItem) {
        
        //alert user of requirements
        let alert = UIAlertController(title: "Hello", message: "For best results please make sure that your face is clearly visible in the picture you select.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        //user confirms pick
        let useAction = UIAlertAction(title: "Use Picture", style: .Default) { (action) in
            
            //default profile pic is set
            defaults.setObject(picToConfirm.source, forKey: "Profile_Picture")
            
            //picture has changed
            /*let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: scoreID)
            user["picture_url"] = picToConfirm.source
            user.pinInBackgroundWithName("Current_User")*/
            if profilePicIsSet() {
                picChanged = true
            }
            else {
                let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: scoreID)
                user["picture_url"] = picToConfirm.source
                user.saveEventually()
                defaults.setBool(true, forKey: "Picture_Is_Set")
            }
            
            //update local url and picture set
            pictureURL = picToConfirm.source
            
            
            //transition
            NSNotificationCenter.defaultCenter().postNotificationName("picSaved", object: nil)
            fromPicConfirm = true
            self.performSegueWithIdentifier("PCVC to MPVC", sender: self)
            self.removeFromParentViewController()
            
            buttonEvent("Picture Confirm", "Confirm")
            
        }
        alert.addAction(useAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        //position picture in view
        let profileImage = RBSquareImage(imgToConfirm)
        self.imageView.image = profileImage
        
    }

}
