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
        
        showActivityIndicator(self.view, isEmbeded: false)
        
        //set up observer for album selection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayAlbumSelection:", name: "albumSelection", object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        //PFObject.unpinAllObjectsInBackgroundWithName("Rated")
        //PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
        
        //check if logged into facebook and parse
        if (FBSDKAccessToken.currentAccessToken() != nil) && PFUser.currentUser() != nil {
            //logged on, queue users and set current user
            self.queueUsers()
            
            //get ad frequency
            PFCloud.callFunctionInBackground("globalSettings", withParameters: ["":""]) {
                (response: AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    let result = response as! String
                    let resultData = result.componentsSeparatedByString(" ")
                    adFrequency = Int(resultData[0])!
                    saveRate = Int(resultData[1])!
                    newUserTime = Int(resultData[2])!
                    newUserCount = Int(resultData[3])!
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
        
        //get a list of already rated users
        let qRated = PFQuery(className: "Score_Data")
        qRated.fromPinWithName("Rated")
        qRated.limit = 1000
        qRated.orderByDescending("index")
        qRated.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                let rated: [PFObject] = objects as! Array
                
                let query = PFQuery(className: "Score_Data")
                query.fromPinWithName("To_Rate")
                query.limit = 1000
                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        
                        pront("Pinned: \(objects?.count)")
                        
                        //if there are less than ten then get some more
                        if objects!.count < 10 {
                            
                            //get max index
                            let qIndex = PFQuery(className: "Max_Index")
                            qIndex.getObjectInBackgroundWithId("ur8NfMGzMl") {
                                (maxIndex: PFObject?, error: NSError?) -> Void in
                                
                                if error != nil {
                                    displayAlertView("Error", message: "There was an error loading data. Please try again later.", action: "Ok", viewController: self)
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
                                                pront("not enough")
                                                unrated = users
                                            }
                                            
                                            //cache all the users and label "To_Rate"
                                            PFObject.pinAllInBackground(unrated, withName: "To_Rate")
                                            
                                            self.organizeUsers(unrated, rated: rated)
                                            
                                        }
                                        else {
                                            displayAlertView("Error", message: "There was an error loading data. Please try again later.", action: "Ok", viewController: self)
                                        }
                                    })
                                }
                            }                            
                        }
                            
                        else {
                            
                            let userList: [PFObject] = objects as! Array
                            pront(userList.count)
                            
                            self.organizeUsers(userList, rated: rated)
                            
                        }
                    }
                    else {
                        displayAlertView("Error", message: "There was an error loading data. Please try again later.", action: "Ok", viewController: self)
                    }
                })
            }
            
            else {
                displayAlertView("Error", message: "There was an error loading data. Please try again later.", action: "Ok", viewController: self)
            }
            
        })
        
    }
    
    func organizeUsers(userArray: [PFObject], rated: [PFObject]) {
        
        //set cutoff time for new users
        let date = NSDate(timeIntervalSinceNow: NSTimeInterval(-newUserTime))
        
        //query for new users and current user
        let predicate = NSPredicate(format: "user == %@ OR (createdAt > %@)", argumentArray: [PFUser.currentUser()!, date])
        let query = PFQuery(className: "Score_Data", predicate: predicate)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                //set up containers to be used later
                let users = objects as! [PFObject]
                var newSmallUsers = [SmallUser]()
                
                //iterate through the found users
                for var i = 0; i < users.count; ++i {
                    let object = users[i]
                    
                    //test if the users user is equal to current user
                    let objectUser = object["user"] as! PFObject
                    if objectUser == PFUser.currentUser() {
                        
                        //set up the settings for current user
                        let user = object
                        pictureURL = user["picture_url"] as! String
                        if pictureURL != "" {
                            defaults.setObject(pictureURL, forKey: "Profile_Picture")
                        }
                        else {
                            defaults.setObject(false, forKey: "Picture_Is_Set")
                        }
                        scoreID = user.objectId!
                        currentUser["Index"] = user["index"] as? Int
                        currentUser["Total_Score"] = user["total_score"] as? Int
                        currentUser["Votes"] = user["votes"] as? Int
                        currentUser["Total_Score_Given"] = user["score_given"] as? Int
                        currentUser["Votes_Given"] = user["votes_given"] as? Int
                        cuScoreDif = (user["score_difference"] as? Double)!
                        cuRank = (user["rank"] as? Double)!
                        currentUser["n10"] = user["n10"] as? Int
                        user.pinInBackgroundWithName("Current_User")
                        
                        
                    }
                        
                    //if its not the current user add the new user to a list of small users
                    else if (object["gender"] as! String == currentGenderPref() || currentGenderPref() == "all") && object["picture_url"] as! String != "" {
                        
                        //make sure these users have not been seen before
                        var duplicate = false
                        for user in rated {
                            if user == object {
                                duplicate = true
                                break
                            }
                        }
                        if !duplicate {
                            newSmallUsers.append(SmallUser(object: object))
                        }
                        
                    }
                    
                    if newSmallUsers.count >= newUserCount {
                        break
                    }
                    
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    //make list of small users
                    for user in userArray {
                        let userToRate = SmallUser(object: user)
                        smallUsersToRate.append(userToRate)
                    }
                    //smallUsersToRate = shuffle(smallUsersToRate)
                    smallUsersToRate = newSmallUsers + smallUsersToRate
                    for x in smallUsersToRate {
                        pront("id: \(x.id), url: \(x.image)")
                    }
                    
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
            else {
                let localQuery = PFQuery(className:"Score_Data")
                localQuery.fromPinWithName("Current_User")
                localQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        let array = objects as! [PFObject]
                        let user = array[0]
                        pictureURL = user["picture_url"] as! String
                        if pictureURL != "" {
                            defaults.setObject(pictureURL, forKey: "Profile_Picture")
                        }
                        scoreID = user.objectId!
                        currentUser["Index"] = user["index"] as? Int
                        currentUser["Total_Score"] = user["total_score"] as? Int
                        currentUser["Votes"] = user["votes"] as? Int
                        currentUser["Total_Score_Given"] = user["score_given"] as? Int
                        currentUser["Votes_Given"] = user["votes_given"] as? Int
                        cuScoreDif = (user["score_difference"] as? Double)!
                        cuRank = (user["rank"] as? Double)!
                        currentUser["n10"] = user["n10"] as? Int
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            
                            //make list of small users
                            for user in userArray {
                                let userToRate = SmallUser(object: user)
                                smallUsersToRate.append(userToRate)
                            }
                            //smallUsersToRate = shuffle(smallUsersToRate)
                            
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
                    else {
                        
                    }
                })
            }
        })
    }
    
    
}
    
    