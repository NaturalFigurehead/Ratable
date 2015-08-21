//
//  Data.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/28/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

//settings---------------------------------------------------------------------------------------------------------------settings

let themeColor = UIColor(red: 205, green: 0, blue: 0, alpha: 1)//UIColor(red: 0.80, green: 0.13333, blue: 0.1725, alpha: 1.0)
var defaults = NSUserDefaults.standardUserDefaults()


var adFrequency = 20
var saveRate = 10
var newUserTime = 3600
var newUserCount = 5

var maximumIndex = 0


var currentVC = 0
var fromPicConfirm = false

var pictureURL = ""
var scoreID = ""
var cuScoreDif: Double = 0
var cuRank: Double = 0
var cuError = false
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
            user.pinInBackgroundWithName("Current_User")
        }
        else {
            var localQuery = PFQuery(className:"Score_Data")
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
                }
                else {
                    
                }
            })
        }
    })
}



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
func ratedNewUsers() -> [String] {
    if defaults.objectForKey("Rated_New_Users") != nil {
        return defaults.objectForKey("Rated_New_Users") as! [String]
    }
    return []
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
    
    //PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
    pront("qr")
    
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
                            pront("Users: \(users)")
                            pront("Unrated: \(unrated)")
                            pront("Rated: \(rated)")
                            
                            //cache all the users and label "To_Rate"
                            PFObject.pinAllInBackground(unrated, withName: "To_Rate")
                            
                            //queue users
                            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                // do some task
                                
                                var smallUserList = [SmallUser]()
                                //create list of small users
                                for user in users {
                                    let userToRate = SmallUser(object: user)
                                    smallUserList.append(userToRate)
                                }
                                smallUserList = shuffle(smallUserList.filter{ !contains(smallUsersToRate, $0) })
                                smallUsersToRate = smallUsersToRate + smallUserList
                                
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

func queueMoreUsers() {
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
                    
                    let users: [PFObject] = objects as! Array

                    //queue users
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        
                        var smallUserList = [SmallUser]()
                        //create list of small users
                        for user in users {
                            let userToRate = SmallUser(object: user)
                            smallUserList.append(userToRate)
                        }
                        smallUserList = shuffle(smallUserList.filter{ !contains(smallUsersToRate, $0) })
                        smallUsersToRate = smallUsersToRate + smallUserList
                        for x in smallUsersToRate {
                            pront("id: \(x.id), url: \(x.image)")
                        }
                        
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

//requests------------------------------------------------------------------------------------------------------requests


func requestedRating() -> String {
    if defaults.objectForKey("Rating") != nil {
        return defaults.objectForKey("Rating") as! String
    }
    return "false"
}

func requestedShare() -> String {
    if defaults.objectForKey("Share") != nil {
        return defaults.objectForKey("Share") as! String
    }
    return "false"
}

func sessionCount() -> Int {
    return defaults.integerForKey("Sessions")
}



func testTimeFetch() {
    pront(1)
    let query = PFQuery(className: "Score_Data")
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
        pront(2)
        if error == nil {
            pront(objects!)
            var x = objects![0] as! PFObject
            pront("5\(x)")
            let y = x.createdAt
            pront("6\(y)")
        }
        else {
            pront(4)
        }
        
    })
}

func newTest() {
    
    //set cutoff time for new users
    let date = NSDate(timeIntervalSinceNow: -10000)
    
    //query for new users and current user
    let predicate = NSPredicate(format: "(createdAt > %@) OR user == %@", argumentArray: [date, PFUser.currentUser()!])
    let query = PFQuery(className: "Score_Data", predicate: predicate)
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
                else if object["gender"] as! String == currentGenderPref() || currentGenderPref() == "all" {
                    newSmallUsers.append(SmallUser(object: object))
                }
                
            }
            
        }
        else {
            var localQuery = PFQuery(className:"Score_Data")
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
                }
                else {
                    
                }
            })
        }
    })
}

/*func setCurrentUser() {
    pront("cu")
    var query = PFQuery(className:"Score_Data")
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
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
            user.pinInBackgroundWithName("Current_User")
        }
        else {
            var localQuery = PFQuery(className:"Score_Data")
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
                }
                else {
                    
                }
            })
        }
    })
}*/




