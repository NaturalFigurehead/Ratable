//
//  InfoViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/31/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit
import MessageUI

class InfoViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var genderPicker: UIPickerView!
    let genders = ["Male", "Female", "All"]
    var n = 0
    
    @IBOutlet weak var loginCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch currentGenderPref(){
        case "male":
            n = 0
        case "female":
            n = 1
        case "all":
            n = 2
        default:
            break
        }
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.selectRow(n, inComponent: 0, animated: false)
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginCell.addSubview(loginView)
        loginView.center.y = 22
        loginView.center.x = self.view.center.x
        loginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
        loginView.delegate = self
        
        buttonEvent("Info", button: "Open")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
            }
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        buttonEvent("Info", button: "Facebook Logout")
        
        PFUser.logOut()
        voteCount = 0
        scoreCount = 0
        scoreDifCount = 0
        picChanged = false
        ratedUsers = [:]
        self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        buttonEvent("Info", button: "Gender Pick")
        
        switch row {
        case 0:
            if currentGenderPref() != "male" {
                defaults.setObject("male", forKey: "Gender_Preference")
                PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
                showActivityIndicator(self.view, isEmbeded: true)
                self.queueUsers()
            }
        case 1:
            if currentGenderPref() != "female" {
                defaults.setObject("female", forKey: "Gender_Preference")
                PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
                showActivityIndicator(self.view, isEmbeded: true)
                self.queueUsers()
            }
            defaults.setObject("female", forKey: "Gender_Preference")
        case 2:
            if currentGenderPref() != "all" {
                defaults.setObject("all", forKey: "Gender_Preference")
                PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
                showActivityIndicator(self.view, isEmbeded: true)
                self.queueUsers()
            }
            defaults.setObject("all", forKey: "Gender_Preference")
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            //remove ads
            PFPurchase.buyProduct("ratable.removeads") {
                (error: NSError?) -> Void in
                if error == nil {
                    pront(1)
                    // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
                    displayAlertView("Success!", message: "Ads will no longer be shown", action: "Ok", viewController: self)
                }
                else {
                    pront(2)
                }
            }
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                //share
                socialShare(self)
                buttonEvent("Info", button: "Share")
            case 1:
                //rate
                goToURL("https://itunes.apple.com/us/app/ratable/id1025633125?ls=1&mt=8")
                buttonEvent("Info", button: "Rate")
            case 2:
                //follow
                goToURL("https://twitter.com/OlivrRzk")
                buttonEvent("Info", button: "Follow")
            case 3:
                //like
                goToURL("https://www.facebook.com/Ratable")
                buttonEvent("Info", button: "Like")
            default:
                break
            }
        }
        else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                //privacy policy
                goToURL("https://itunes.apple.com/us/app/ratable/id1025633125?ls=1&mt=8")
                buttonEvent("Info", button: "Privacy Policy")
            case 1:
                //terms of service
                goToURL("https://itunes.apple.com/us/app/ratable/id1025633125?ls=1&mt=8")
                buttonEvent("Info", button: "Terms of Service")
            default:
                break
            }
        }
        else if indexPath.section == 3 {
            //contact
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            buttonEvent("Info", button: "Email")
        }
        else if indexPath.section == 4 && indexPath.row == 1 {
            
            //delete account
            
            let alert = UIAlertController(title: "Continue?", message: "Your account will be deleted and your data lost.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            //user confirms deletion
            let useAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                
                buttonEvent("Info", button: "Delete")
                
                //delete user data on score data object
                let data = PFObject(withoutDataWithClassName: "Score_Data", objectId: scoreID)
                data["picture_url"] = ""
                data["first_name"] = ""
                data.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        //delete user
                        PFUser.currentUser()?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            if success {
                                
                                //revert save value
                                voteCount = 0
                                scoreCount = 0
                                scoreDifCount = 0
                                picChanged = false
                                ratedUsers = [:]
                                
                                //unpin cached users to rate
                                PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
                                
                                //logout of facebook
                                let loginManager = FBSDKLoginManager()
                                loginManager.logOut()
                                
                                //logout user
                                PFUser.logOut()
                                
                                //move to login view
                                self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
                                
                            }
                        })
                    }
                    else {
                        
                    }
                })
                
            }
            alert.addAction(useAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["olrdev@yahoo.com"])
        mailComposerVC.setSubject("From Ratable")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func queueUsers() {
        
        //PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
        pront("q")
        
        //get a list of already rated users
        let qRated = PFQuery(className: "Score_Data")
        qRated.fromPinWithName("Rated")
        qRated.limit = 1000
        qRated.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                //get max index
                let rated: [PFObject] = objects as! Array
                let qIndex = PFQuery(className: "Max_Index")
                qIndex.getObjectInBackgroundWithId("ur8NfMGzMl") {
                    (maxIndex: PFObject?, error: NSError?) -> Void in
                    
                    if error != nil {
                        pront("error")
                    }
                        
                    else if let maxIndex = maxIndex {
                        
                        //list random indexes in the max index range
                        var indexes: [Int] = []
                        let max = maxIndex["i"] as! Int
                        var i = 0
                        while i < 900 && max > 100 {
                            let n = randRange(1, upper: max - 100)
                            indexes.append(n)
                            i += 1
                        }
                        i = 0
                        while i < 100 {
                            let n = (max - i)
                            indexes.append(n)
                            i += 1
                        }
                        indexes.sortInPlace {
                            return $0 < $1
                        }
                        
                        //fetch users with those indexes
                        let qUser = PFQuery(className: "Score_Data")
                        qUser.whereKey("index", containedIn: indexes)
                        if currentGenderPref() != "all" {
                            qUser.whereKey("gender", equalTo: currentGenderPref())
                        }
                        qUser.whereKey("picture_url", notEqualTo: "")
                        qUser.limit = 1000
                        qUser.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                
                                //filter users
                                let users: [PFObject] = objects as! Array
                                var unrated: [PFObject] = users.filter{ !rated.contains($0) }
                                if unrated.count < 6 {
                                    unrated = users
                                }
                                
                                //cache all the users and label "To_Rate"
                                PFObject.pinAllInBackground(unrated, withName: "To_Rate")
                                
                                //queue users
                                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                    
                                    // set values to start values
                                    smallUsersToRate = []
                                    usersToRate = []
                                    userNum = 0
                                    
                                    //create list of small users
                                    for user in users {
                                        let userToRate = SmallUser(object: user)
                                        smallUsersToRate.append(userToRate)
                                    }
                                    //smallUsersToRate = shuffle(smallUsersToRate)
                                    
                                    //queue of users
                                    var i = 0
                                    while i < 5 {
                                        let userToRate = User(user: smallUsersToRate[i])
                                        usersToRate.append(userToRate)
                                        i += 1
                                    }
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        
                                        //move to next view controller
                                        self.presentViewController(vcWithName("MPVCNC")!, animated: true, completion: nil)
                                        
                                    }
                                }
                            }
                            else {
                                
                            }
                        })
                    }
                }
            }
            else {
            }
        })
        
        
        
    }
    
}
