//
//  Data.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/28/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

//settings---------------------------------------------------------------------------------------------------------------settings

//let themeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)//UIColor(red: 0.80, green: 0.13333, blue: 0.1725, alpha: 1.0)
var defaults = NSUserDefaults.standardUserDefaults()

var currentVC = 0
var fromPicConfirm = false

var pictureURL = ""
var scoreID = ""
var cuScoreDif: Double = 0
var currentUser: [String: Int] = Dictionary()
func setCurrentUser() {
    pront("cu")
    var query = PFQuery(className:"Score_Data")
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
        if error == nil {
            let array = objects as! [PFObject]
            let user = array[0]
            pictureURL = user["picture_url"] as! String
            defaults.setObject(pictureURL, forKey: "Profile_Picture")
            scoreID = user.objectId!
            currentUser["Index"] = user["index"] as? Int
            currentUser["Total_Score"] = user["score"] as? Int
            currentUser["Votes"] = user["votes"] as? Int
            currentUser["Total_Score_Given"] = user["score_given"] as? Int
            currentUser["Votes_Given"] = user["votes_given"] as? Int
            cuScoreDif = (user["score_difference"] as? Double)!
            currentUser["n10"] = user["n10"] as? Int
        }
    })
}

var adFrequency = 20

/*func ssetCurrentUser() {
    pront("cu")
    var query = PFQuery(className:"Users")
    query.getObjectInBackgroundWithId(currentParseID()) {
        (user: PFObject?, error: NSError?) -> Void in
        if error != nil {
            pront("error")
        } else if let user = user {
            currentUserI["Index"] = user["Index"] as? Int
            currentUserS["Facebook_ID"] = user["Facebook_ID"] as? String
            currentUserS["Name"] = user["Name"] as? String
            currentUserS["First_Name"] = user["First_Name"] as? String
            currentUserS["Email"] = user["Email"] as? String
            currentUserS["Gender"] = user["Gender"] as? String
            currentUserS["Location"] = user["Location"] as? String
            currentUserS["Picture_URL"] = user["Picture_URL"] as? String
            currentUserI["Total_Score"] = user["Total_Score"] as? Int
            currentUserI["Votes"] = user["Votes"] as? Int
            currentUserI["Total_Score_Given"] = user["Total_Score_Given"] as? Int
            currentUserI["Votes_Given"] = user["Votes_Given"] as? Int
            currentUserI["n10"] = user["n10"] as? Int
        }
    }
}*/

/*func getCurrentUser() {
    PFCloud.callFunctionInBackground("getCurrentUser", withParameters: ["id": currentParseID()]) {
        (response: AnyObject?, error: NSError?) -> Void in
        let user = response as! PFObject
        currentUserI["Index"] = user["Index"] as? Int
        currentUserS["Facebook_ID"] = user["Facebook_ID"] as? String
        currentUserS["Name"] = user["Name"] as? String
        currentUserS["First_Name"] = user["First_Name"] as? String
        currentUserS["Email"] = user["Email"] as? String
        currentUserS["Gender"] = user["Gender"] as? String
        currentUserS["Location"] = user["Location"] as? String
        currentUserS["Picture_URL"] = user["Picture_URL"] as? String
        currentUserI["Total_Score"] = user["Total_Score"] as? Int
        currentUserI["Votes"] = user["Votes"] as? Int
        currentUserI["Total_Score_Given"] = user["Total_Score_Given"] as? Int
        currentUserI["Votes_Given"] = user["Votes_Given"] as? Int
        currentUserI["n10"] = user["n10"] as? Int
    }
}*/

func currentID() -> String {
    if defaults.objectForKey("Facebook_ID") != nil {
        return defaults.objectForKey("Facebook_ID") as! String
    }
    return "notset"
}
func currentProfilePic() -> String {
    if defaults.objectForKey("Profile_Picture") != nil {
        return defaults.objectForKey("Profile_Picture") as! String
    }
    return "notset"
}
func profilePicIsSet() -> Bool {
    return defaults.boolForKey("Picture_Is_Set")
}
func currentGenderPref() -> String {
    if defaults.objectForKey("Gender_Preference") != nil {
        return defaults.objectForKey("Gender_Preference") as! String
    }
    return "notset"
}
func currentParseID() -> String {
    if defaults.objectForKey("Parse_ID") != nil {
        return defaults.objectForKey("Parse_ID") as! String
    }
    return "notset"
}
func mainID() -> String {
    if defaults.objectForKey("Main_User_ID") != nil {
        return defaults.objectForKey("Main_User_ID") as! String
    }
    return "notset"
}
func adsRemoved() -> String {
    if defaults.objectForKey("Ads_Removed") != nil {
        return defaults.objectForKey("Ads_Removed") as! String
    }
    return "false"
}


var currentUserToSave = PFObject(className: "Score_Data")



//save----------------------------------------------------------------------------------------------------------------------save


var voteCount = 0
var scoreCount = 0
var scoreDifCount: Double = 0
var picChanged = false

var ratedUsers: [String: String] = [:]


//main-----------------------------------------------------------------------------------------------------------------------main

var isNewUser = true

//album---------------------------------------------------------------------------------------------------------------------album

var albums: [Album] = []

//pictureselect-----------------------------------------------------------------------------------------------------pictureselect

var pictures: [Picture] = []
var bestSize = CGSizeMake(150, 150)


//pictureconfirm---------------------------------------------------------------------------------------------------pictureconfirm

var picToConfirm: Picture = Picture(source: "http://i.stack.imgur.com/yu61M.png", id: "")
var imgToConfirm: UIImage = UIImage()

//rate-----------------------------------------------------------------------------------------------------------------
var usersToRate: [User] = []
var smallUsersToRate: [SmallUser] = []
var userNum = 0
var userCount = 5
var picsLoaded = false

func queueUsers() {
    
    PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
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
                                pront("error")
                            }
                                
                            else if let maxIndex = maxIndex {
                                
                                //list random indexes in the max index range
                                var indexes: [Int] = []
                                var max = maxIndex["i"] as! Int
                                var i = 0
                                while i < 1000 {
                                    let n = randRange(1, max)
                                    indexes.append(n)
                                    i += 1
                                }
                                indexes.sort {
                                    return $0 < $1
                                }
                                pront(indexes.count)
                                
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
                                                
                                                picsLoaded = true
                                                
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
                
            else {
                
                let userList: [PFObject] = objects as! Array
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
                        let userToRate = User(user: smallUsersToRate[i])
                        usersToRate.append(userToRate)
                        i += 1
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        picsLoaded = true
                        
                    }
                }
            }
        }
        else {
            
        }
    })
    
}

//rating request------------------------------------------------------------------------------------------------------Rating request

