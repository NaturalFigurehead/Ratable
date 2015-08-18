//
//  ViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/16/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(self.view, false)
        
        //set up observer for album selection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayAlbumSelection:", name: "albumSelection", object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        //check if logged into facebook and parse
        if (FBSDKAccessToken.currentAccessToken() != nil) && PFUser.currentUser() != nil {
            //logged on, queue users and set current user
            setCurrentUser()
            self.queueUsers()
            
            //get ad frequency
            if adsRemoved() == "false" {
                PFCloud.callFunctionInBackground("globalSettings", withParameters: ["":""]) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        let result = response as! String
                        let resultData = result.componentsSeparatedByString(" ")
                        adFrequency = resultData[0].toInt()!
                        saveRate = resultData[1].toInt()!
                    }
                }
            }
            //self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
        }
        else {
            self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
        }
    }
    
    func presentMaster() {
        self.presentViewController(vcWithName("MPVCNC")!, animated: true, completion: nil)
    }
    
    func displayAlbumSelection(note: NSNotification) {
        if currentVC == 0 {
            self.performSegueWithIdentifier("VC to ASVC", sender: self)
        }
    }
    
    
    func queueUsers() {
        
        //PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
        pront("q")
        
        //check if enough users to rate are cached
        let query = PFQuery(className: "Score_Data")
        query.fromPinWithName("To_Rate")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                //if there are less than ten then get some more
                if objects!.count < 10 {
                    
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
                                    displayAlertView("Error", "There was an error loading data. Please try again later.", "Ok", self)
                                }
                                
                                else if let maxIndex = maxIndex {
                                    
                                    //list random indexes in the max index range
                                    var indexes: [Int] = []
                                    var max = maxIndex["i"] as! Int
                                    var i = 0
                                    while i < 900 && max > 100 {
                                        let n = randRange(1, max - 100)
                                        indexes.append(n)
                                        i += 1
                                    }
                                    i = 0
                                    while i < 100 {
                                        let n = (max - i)
                                        indexes.append(n)
                                        i += 1
                                    }
                                    indexes.sort {
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
                                            let unrated: [PFObject] = users.filter{ !contains(rated, $0) }
                                            
                                            //cache all the users and label "To_Rate"
                                            PFObject.pinAllInBackground(unrated, withName: "To_Rate")
                                            
                                            //queue users
                                            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                                            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                                // do some task
                                                
                                                //create list of small users
                                                for user in users {
                                                    let userToRate = SmallUser(object: user)
                                                    smallUsersToRate.append(userToRate)
                                                }
                                                smallUsersToRate = shuffle(smallUsersToRate)
                                                
                                                //queue of users
                                                var i = 0
                                                while i < 5 {
                                                    let userToRate = User(user: smallUsersToRate[i])
                                                    usersToRate.append(userToRate)
                                                    i += 1
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue()) {
                                                    
                                                    // move on
                                                    picsLoaded = true
                                                    if profilePicIsSet() {
                                                        self.presentMaster()
                                                    }
                                                    else {
                                                        getAlbumData()
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        else {
                                            displayAlertView("Error", "There was an error loading data. Please try again later.", "Ok", self)
                                        }
                                    })
                                }
                            }
                        }
                            
                        else {
                            displayAlertView("Error", "There was an error loading data. Please try again later.", "Ok", self)
                        }
                    })
                }
                
                else {

                    let userList: [PFObject] = objects as! Array
                    pront(userList.count)
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        
                        //make list of small users
                        for user in userList {
                            let userToRate = SmallUser(object: user)
                            smallUsersToRate.append(userToRate)
                        }
                        smallUsersToRate = shuffle(smallUsersToRate)
                        
                        //queue up users
                        var i = 0
                        while i < 5 {
                            pront(smallUsersToRate[i].id)
                            let userToRate = User(user: smallUsersToRate[i])
                            usersToRate.append(userToRate)
                            i += 1
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // move on
                            picsLoaded = true
                            if profilePicIsSet() {
                                self.presentMaster()
                            }
                            else {
                                getAlbumData()
                            }
                            
                        }
                    }
                }
            }
            else {
                displayAlertView("Error", "There was an error loading data. Please try again later.", "Ok", self)
            }
        })
        
    }
}
    
    