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
                PFCloud.callFunctionInBackground("adFrequency", withParameters: ["":""]) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        adFrequency = response as! Int
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
                                    pront("error")
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
                                                    
                                                    //move to next view controller
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
                
            }
        })
        
    }
}
    
    /*func queueUsers2() {
        PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
        pront("q")
        //check if enough users to rate are cached
        let query = PFQuery(className: "Users")
        query.fromPinWithName("To_Rate")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                //if there are less than ten then get some more
                if objects!.count < 10 {
                    pront("something")
                    //get a list of already rated users
                    let query2 = PFQuery(className: "Users")
                    query2.fromPinWithName("Rated")
                    query2.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            let rated: [PFObject] = objects as! Array
                            let query3 = PFQuery(className: "Max_Index")
                            query3.getObjectInBackgroundWithId("GdsteUx5am") {
                                (maxIndex: PFObject?, error: NSError?) -> Void in
                                if error != nil {
                                    pront("error")
                                } else if let maxIndex = maxIndex {
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
                                    var y = -1
                                    var z = 0
                                    for x in indexes {
                                        if x == y {
                                            z += 1
                                        }
                                        y = x
                                    }
                                    pront(z)
                                    pront(indexes.count)
                                    //fetch users with those indexes
                                    let uQuery = PFQuery(className: "Users")
                                    uQuery.whereKey("Index", containedIn: indexes)
                                    pront(currentGenderPref())
                                    if currentGenderPref() != "all" {
                                        uQuery.whereKey("Gender", equalTo: currentGenderPref())
                                    }
                                    uQuery.limit = 1000
                                    uQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                                        if error == nil {
                                            let users: [PFObject] = objects as! Array
                                            let unrated: [PFObject] = users.filter{ !contains(rated, $0) }
                                            //cache all the users and label "To_Rate"
                                            PFObject.pinAllInBackground(unrated, withName: "To_Rate")
                                            //queue users
                                            //usersToRate = []
                                            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                                            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                                // do some task
                                                for user in users {
                                                    let userToRate = SmallUser(object: user)
                                                    smallUsersToRate.append(userToRate)
                                                }
                                                smallUsersToRate = shuffle(smallUsersToRate)
                                                var i = 0
                                                while i < 5 {
                                                    let userToRate = User(user: smallUsersToRate[i])
                                                    usersToRate.append(userToRate)
                                                    i += 1
                                                }
                                                dispatch_async(dispatch_get_main_queue()) {
                                                    picsLoaded = true
                                                    if (FBSDKAccessToken.currentAccessToken() != nil) {
                                                        if profilePicIsSet() {
                                                            self.presentMaster()
                                                        }
                                                        else {
                                                            getAlbumData()
                                                        }
                                                    }
                                                    else {
                                                        self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
                                                    }
                                                    
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
                    //get the max index of all users
                }
                    //if there are ten then empty then add them to the global list
                else {
                    //smallUsersToRate = []
                    let userList: [PFObject] = objects as! Array
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        for user in userList {
                            let userToRate = SmallUser(object: user)
                            smallUsersToRate.append(userToRate)
                        }
                        smallUsersToRate = shuffle(smallUsersToRate)
                        var i = 0
                        while i < 5 {
                            let userToRate = User(user: smallUsersToRate[i])
                            usersToRate.append(userToRate)
                            i += 1
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            picsLoaded = true
                            pront("picsloaded")
                            if (FBSDKAccessToken.currentAccessToken() != nil) {
                                if profilePicIsSet() {
                                    self.presentMaster()
                                }
                                else {
                                    getAlbumData()
                                }
                            }
                            else {
                                self.presentViewController(vcWithName("LVC")!, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
            }
            else {
                
            }
        })
    }

    
}*/

    
    
    
    
    
    
    
    /*@IBAction func loginAction(sender: UIButton) {
        /*let maxIndex = PFObject(withoutDataWithClassName: "Max_Index", objectId: "GdsteUx5am")
        maxIndex["i"] = 0
        maxIndex.saveInBackground()*/
        
        /*let query = PFQuery(className: "Max_Index")
        query.getObjectInBackgroundWithId("GdsteUx5am") {
            (maxIndex: PFObject?, error: NSError?) -> Void in
            if error != nil {
                pront("error")
            } else if let maxIndex = maxIndex {
                var indexes: [Int] = []
                var max = maxIndex["i"] as! Int
                var i = 0
                while i < 1000 {
                    let n = randRange(0, max)
                    indexes.append(n)
                    i += 1
                }
                let uQuery = PFQuery(className: "Users")
                uQuery.whereKey("Index", containedIn: indexes)
                uQuery.limit = 1000
                uQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        let users = objects as! [PFObject]
                        for user in users {
                            pront(user.objectId!)
                            user.pinInBackgroundWithName("To_Rate")
                        }
                    }
                    else {
                        
                    }
                })
            }
        }*/
        
        let query = PFQuery(className: "Users")
        query.fromPinWithName("To_Rate")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                pront(objects!.count)
            }
            else {
                
            }
        })
        
        let query2 = PFQuery(className: "Users")
        query2.fromPinWithName("Rated")
        query2.limit = 1000
        query2.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                pront("s")
                pront(objects!.count)
            }
            else {
                
            }
        })

        var i = 0
        while i < 1000 {
            var query = PFQuery(className: "Max_Index")
            query.getObjectInBackgroundWithId("GdsteUx5am") {
                (maxIndex: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    pront("error")
                } else if let maxIndex = maxIndex {
                    let user = PFObject(className: "Users")
                    let index = maxIndex["i"] as! Int
                    user["Index"] = index + 1
                    maxIndex.incrementKey("i", byAmount: 1)
                    maxIndex.saveInBackground()
                    user["Name"] = "Name"
                    user["First_Name"] = "Name"
                    user["Gender"] = "female"
                    user["Picture_URL"] = "http://lorempixel.com/1000/1000/"
                    user["Total_Score"] = 0
                    user["Votes"] = 0
                    var i = 0
                    while i < 11 {
                        user["n\(i)"] = 0
                        i += 1
                    }
                    //set gender preference based on gender
                    //save user
                    user.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            
                        }
                        else {
                        }
                    }
                }
            }
            i += 1
        }*/

    
    /*override func viewDidLoad() {
        //PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            // Or Show Logout Button
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
            loginView.delegate = self
            if profilePicIsSet() {
                //getAlbumData()
            }
            else {
                //getAlbumData()
            }
        }
        else {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
            loginView.delegate = self
        }
    }
    
    // Facebook Delegate Methods
    
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
            setDefaultID()
            //pront("FBSignin")
            //signIn()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOut()
    }
    
    func setDefaultID() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            defaults.setValue(result["id"] as! String, forKey: "Facebook_ID")
            self.newAccount()
        })
    }
    
    var isNewUserWasSet = false {
        didSet{
            if isNewUserWasSet {
                if isNewUser {
                    setAccountData()
                    defaults.setBool(false, forKey: "Picture_Is_Set")
                    getAlbumData()
                }
                else {
                    if profilePicIsSet() == false {
                        getAlbumData()
                    }
                    else {
                        //move to next vc
                    }
                }
            }
        }
    }
    
    func newAccount() {
        var query = PFQuery(className: "Users")
        query.whereKey("Facebook_ID", equalTo: currentID())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                //let user = objects as NSArray
                // The find succeeded.
                // Do something with the found objects
                if objects?.count > 0 {
                    defaults.setObject(objects![0].objectId, forKey: "Parse_ID")
                    isNewUser = false
                }
                else {
                    isNewUser = true
                }
            }
            else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            self.isNewUserWasSet = true
        }
    }
    
    func setAccountData() {
        //check if logged into facebook
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //access facebook profile info
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                var query = PFQuery(className: "Max_Index")
                query.getObjectInBackgroundWithId("GdsteUx5am") {
                    (maxIndex: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        pront("error")
                    } else if let maxIndex = maxIndex {
                        let user = PFObject(className: "Users")
                        let index = maxIndex["i"] as! Int
                        user["Index"] = index + 1
                        maxIndex.incrementKey("i", byAmount: 1)
                        maxIndex.saveInBackground()
                        user["Facebook_ID"] = result["id"]
                        user["Name"] = result["name"]
                        user["First_Name"] = result["first_name"]
                        user["Email"] = result["email"]
                        user["Gender"] = result["gender"]
                        user["Location"] = result["locale"]
                        user["Picture_URL"] = ""
                        user["Total_Score"] = 0
                        user["Votes"] = 0
                        user["Total_Score_Given"] = 0
                        user["Votes_Given"] = 0
                        var i = 0
                        while i < 11 {
                            user["n\(i)"] = 0
                            i += 1
                        }
                        //set gender preference based on gender
                        if result["gender"] as! String == "male" {
                            defaults.setValue("female", forKey: "Gender_Preference")
                        }
                        else if result["gender"] as! String == "female" {
                            defaults.setValue("male", forKey: "Gender_Preference")
                        }
                        else {
                            defaults.setValue("all", forKey: "Gender_Preference")
                        }
                        //save user
                        user.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                //set the default parse ID, find a user block for the user
                                defaults.setObject(user.objectId, forKey: "Parse_ID")
                                setCurrentUser()
                                PFObject.unpinAllObjectsInBackgroundWithName("Main_User")
                                user.pinInBackgroundWithName("Main_User", block: { (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                    }
                                })
                                
                            }
                            else {
                            }
                        }
                    }
                }
                //create user object, assign properties
                
            })
        }
    }
    
    func signIn() {
        pront("ParseSignIn1")
        //check if logged into facebook
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            pront("ParseSignIn2")
            //access facebook profile info
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                pront("ParseSignIn3")
                var query = PFQuery(className: "Max_Index")
                query.getObjectInBackgroundWithId("GdsteUx5am") {
                    (maxIndex: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        pront("error")
                    } else if let maxIndex = maxIndex {
                        pront("ParseSignIn4")
                        let user = PFUser()
                        user.username = result["id"] as? String
                        user.password = ""
                        user["Facebook_ID"] = result["id"]
                        user["Name"] = result["name"]
                        user["First_Name"] = result["first_name"]
                        user["Email"] = result["email"]
                        user["Gender"] = result["gender"]
                        user["Location"] = result["locale"]
                        user["Picture_URL"] = ""
                        user["Total_Score_Given"] = 0
                        user["Votes_Given"] = 0
                        user["Score_Difference"] = 0
                        //set gender preference based on gender
                        if result["gender"] as! String == "male" {
                            defaults.setValue("female", forKey: "Gender_Preference")
                        }
                        else if result["gender"] as! String == "female" {
                            defaults.setValue("male", forKey: "Gender_Preference")
                        }
                        else {
                            defaults.setValue("all", forKey: "Gender_Preference")
                        }
                        //set up score data
                        let scoreData = PFObject(className: "Score_Data")
                        let index = maxIndex["i"] as! Int
                        scoreData["Index"] = index + 1
                        maxIndex.incrementKey("i", byAmount: 1)
                        scoreData["Total_Score"] = 0
                        scoreData["Votes"] = 0
                        var i = 0
                        while i < 11 {
                            scoreData["n\(i)"] = 0
                            i += 1
                        }
                        scoreData["User"] = user
                        user["Score_Data"] = scoreData
                        //save user
                        user.signUpInBackgroundWithBlock {
                            (succeeded: Bool, error: NSError?) -> Void in
                            pront("ParseSignIn5")
                            if let error = error {
                                pront("err")
                                let errorString = error.userInfo?["error"] as? NSString
                                let id: String = result["id"] as! String
                                let expectedError = "username \(id) already taken"
                                if errorString! == expectedError {
                                    PFUser.logInWithUsernameInBackground(id, password:"") {
                                        (user: PFUser?, error: NSError?) -> Void in
                                        if user != nil {
                                            defaults.setObject(user!.objectId, forKey: "Parse_ID")
                                            // Do stuff after successful login.
                                            if profilePicIsSet() != true {
                                                defaults.setBool(false, forKey: "Picture_Is_Set")
                                                self.getAlbumData()
                                            }
                                            else {
                                                //continue to rate view controller
                                            }
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }
                                }
                                // Show the errorString somewhere and let the user try again.
                            } else {
                                pront("success")
                                defaults.setObject(user.objectId, forKey: "Parse_ID")
                                defaults.setBool(false, forKey: "Picture_Is_Set")
                                maxIndex.saveInBackground()
                                scoreData.saveInBackground()
                                self.getAlbumData()
                            }
                        }
                    }
                }
            })
        }
    }
    
    func signUp() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                var user = PFUser()
                user.username = result["id"] as? String
                user.password = ""
                user["Facebook_ID"] = result["id"] as? String
                user["Name"] = result["name"] as? String
                user["First_Name"] = result["first_name"] as? String
                user["Email"] = result["email"] as? String
                user["Gender"] = result["gender"] as? String
                user["Location"] = result["locale"] as? String
                user["Picture_URL"] = ""
                user["Total_Score"] = 0
                user["Votes"] = 0
                if result["gender"] as! String == "male" {
                    user["Gender_Preference"] = "female"
                    defaults.setValue("female", forKey: "Gender_Preference")
                }
                else if result["gender"] as! String == "female" {
                    user["Gender_Preference"] = "male"
                    defaults.setValue("male", forKey: "Gender_Preference")
                }
                else {
                    user["Gender_Preference"] = "all"
                    defaults.setValue("all", forKey: "Gender_Preference")
                }
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        let id: String = result["id"] as! String
                        let expectedError = "username \(id) already taken"
                        if errorString! == expectedError {
                            PFUser.logInWithUsernameInBackground(id, password:"") {
                                (user: PFUser?, error: NSError?) -> Void in
                                if user != nil {
                                    // Do stuff after successful login.
                                    if profilePicIsSet() != true {
                                        defaults.setBool(false, forKey: "Picture_Is_Set")
                                        self.getAlbumData()
                                    }
                                    else {
                                        //continue to rate view controller
                                    }
                                } else {
                                    // The login failed. Check error to see why.
                                }
                            }
                        }
                        // Show the errorString somewhere and let the user try again.
                    } else {
                        defaults.setBool(false, forKey: "Picture_Is_Set")
                        self.getAlbumData()
                    }
                }
            })
        }
    }
    
    var albumsDidChange = 0 {
        didSet{
            if albumsDidChange == 2 {
                self.performSegueWithIdentifier("VC to ASVC", sender: self)
            }
        }
    }
    
    func getAlbumData() {
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            albums = []
            let graphRequestMePhotos : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/photos", parameters: nil)
            graphRequestMePhotos.startWithCompletionHandler({ (connection, result, error) -> Void in
                let data = result["data"] as! NSArray
                let name = "Photos of You"
                let photoCount = data.count
                let id = "me"
                albums.append(Album(name: name, photos: photoCount, id: id))
                self.albumsDidChange += 1
            })
            let graphRequestAlbums : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/albums", parameters: nil)
            graphRequestAlbums.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                let data = result["data"] as! NSArray
                for album in data {
                    
                    let name = album["name"] as! String
                    let photoCount = album["count"] as! Int
                    let id = album["id"] as! String
                    albums.append(Album(name: name, photos: photoCount, id: id))
                    
                }
                self.albumsDidChange += 1
            })
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
//}
