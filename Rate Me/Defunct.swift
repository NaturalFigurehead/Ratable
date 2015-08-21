//
//  Defunct.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/16/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit


//check if enough users to rate are cached
/*let query = PFQuery(className: "Score_Data")
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

self.organizeUsers(unrated)

//queue users
/*let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
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
}*/
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

self.organizeUsers(userList)

/*let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
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
}*/
}
}
else {
displayAlertView("Error", "There was an error loading data. Please try again later.", "Ok", self)
}
})*/

/*var usersQueued = false {
didSet {
if usersQueued {
//self.avgScore.text = String(stringInterpolationSegment: usersToRate[userNum].score)
self.imageView.image = usersToRate[userNum].image
}
}
}

func queueUsersR() {
//PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
//check if enough users to rate are cached
let query = PFQuery(className: "Users")
query.fromPinWithName("To_Rate")
//query.skip = userNum
query.limit = 1
query.skip = 10 + userNum
query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
if error == nil {
//if there are less than ten then get some more
if objects!.count < 1 {
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
let n = randRange(0, max)
indexes.append(n)
i += 1
}
indexes.sort {
return $0 < $1
}
pront(indexes)
pront(indexes.count)
//fetch users with those indexes
let uQuery = PFQuery(className: "Users")
uQuery.whereKey("Index", containedIn: indexes)
uQuery.whereKey("Gender", equalTo: currentGenderPref())
uQuery.limit = 1000
uQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
if error == nil {
let users: [PFObject] = objects as! Array
let unrated: [PFObject] = users.filter{ !contains(rated, $0) }
//cache all the users and label "To_Rate"
for user in unrated {
user.pinInBackgroundWithName("To_Rate")
}
//usersToRate = []
let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
dispatch_async(dispatch_get_global_queue(priority, 0)) {
// do some task
let pfUserToRate = unrated[0]
let userToRate = User(object: pfUserToRate)
dispatch_async(dispatch_get_main_queue()) {
//self.avgScore.text = String(stringInterpolationSegment: usersToRate[userNum].score)
//self.imageView.image = usersToRate[userNum].image
//picsLoaded = true
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
//usersToRate = []
let userList: [PFObject] = objects as! Array
let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
dispatch_async(dispatch_get_global_queue(priority, 0)) {
// do some task
for user in userList {
let userToRate = User(object: user)
usersToRate.append(userToRate)
}
dispatch_async(dispatch_get_main_queue()) {
//self.avgScore.text = String(stringInterpolationSegment: usersToRate[userNum].score)
//self.imageView.image = usersToRate[userNum].image
//picsLoaded = true
pront("Count: \(usersToRate.count)")
}
}
//self.usersQueued = true
}
}
else {
}
})
}*/

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


//LOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGINLOGIN

/*func setDefaultID() {
let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
defaults.setValue(result["id"] as! String, forKey: "Facebook_ID")
//self.newAccount()
self.signUp()
})
}

var isNewUserWasSet = false {
didSet{
if isNewUserWasSet {
if isNewUser {
setAccountData()
defaults.setBool(false, forKey: "Picture_Is_Set")
//getAlbumData()
//self.presentViewController(ViewController(), animated: true, completion: nil)
}
else {
if profilePicIsSet() == false {
//getAlbumData()
//self.presentViewController(ViewController(), animated: true, completion: nil)
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
pront("sac1")
//check if logged into facebook
if (FBSDKAccessToken.currentAccessToken() != nil) {
pront("sac2")
//access facebook profile info
let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, email, name, locale, gender"])
graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
pront("sac3")
var query = PFQuery(className: "Max_Index")
query.getObjectInBackgroundWithId("GdsteUx5am") {
(maxIndex: PFObject?, error: NSError?) -> Void in
pront("sac4")
if error != nil {
pront("error")
} else if let maxIndex = maxIndex {
pront("sac5")
pront(maxIndex)
let user = PFObject(className: "Users")
let index = maxIndex["i"] as! Int
user["Index"] = index + 1
maxIndex.incrementKey("i", byAmount: 1)
maxIndex.saveInBackground()
pront(result)
user["Facebook_ID"] = result["id"]
user["Name"] = result["name"]
user["First_Name"] = result["first_name"]
user["Email"] = result["email"]
user["Location"] = result["locale"]
user["Gender"] = result["gender"]
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
pront("sac6")
if (success) {
pront("sac7")
//set the default parse ID, find a user block for the user
defaults.setObject(user.objectId, forKey: "Parse_ID")
PFObject.unpinAllObjectsInBackgroundWithName("Main_User")
user.pinInBackgroundWithName("Main_User", block: { (success: Bool, error: NSError?) -> Void in
if (success) {
}
})
self.presentViewController(ViewController(), animated: true, completion: nil)
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

//check if logged into facebook
if (FBSDKAccessToken.currentAccessToken() != nil) {

//access facebook profile info
let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, email, name, locale, gender"])
graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

//get the max index
var query = PFQuery(className: "Max_Index")
query.getObjectInBackgroundWithId("GdsteUx5am") {
(maxIndex: PFObject?, error: NSError?) -> Void in
if error != nil {

//error

} else if let maxIndex = maxIndex {

pront("ParseSignIn4")
//create user
let user = PFUser()

pront(1)
//set user properties
user.username = result["id"] as? String
user.password = ""
user["Facebook_ID"] = result["id"]
user["Name"] = result["name"]
user["Email"] = result["email"]
user["Location"] = result["locale"]
user["Total_Score_Given"] = 0
user["Votes_Given"] = 0
user["Score_Difference"] = 0

pront(2)
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

pront(3)
//set user acl
//user.ACL = PFACL(user: user)

pront(4)
//create score data object
let scoreData = PFObject(className: "Score_Data")

pront(5)
//set score data properties
let index = maxIndex["i"] as! Int
scoreData["Index"] = index + 1
user["First_Name"] = result["first_name"]
user["Gender"] = result["gender"]
user["Picture_URL"] = ""
scoreData["Total_Score"] = 0
scoreData["Votes"] = 0
var i = 0
while i < 11 {
scoreData["n\(i)"] = 0
i += 1
}
scoreData["User"] = user

pront(6)
//increment max index
maxIndex.incrementKey("i", byAmount: 1)

pront(7)
//sign up user
user.signUpInBackgroundWithBlock {
(succeeded: Bool, error: NSError?) -> Void in

pront("ParseSignIn5")
if let error = error {

//check if existing user
pront("err")
let errorString = error.userInfo?["error"] as? NSString
let id: String = result["id"] as! String
let expectedError = "username \(id) already taken"
if errorString! == expectedError {

//login existing user
PFUser.logInWithUsernameInBackground(id, password:"") {
(user: PFUser?, error: NSError?) -> Void in

if user != nil {

//set parse id
defaults.setObject(user!.objectId, forKey: "Parse_ID")

//check if they have a profile pick and send to pick one if necessary
if profilePicIsSet() != true {
getAlbumData()
}

//continue to main
else {
self.presentViewController(vcWithName("MPVCNC")!, animated: true, completion: nil)
}

} else {
// The login failed. Check error to see why.
}
}
}
}

//sign up succeeded
else {

//set parse id and picture defaults
pront("success")
defaults.setObject(user.objectId, forKey: "Parse_ID")
defaults.setBool(false, forKey: "Picture_Is_Set")

//save maxIndex and score data
maxIndex.saveInBackground()
scoreData.saveInBackground()

//get album data and move to next view controller
getAlbumData()
}
}
}
}
})
}
}*/

/*var albumsDidChange = 0 {
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
}*/

/*var query = PFQuery(className: "User_Blocks")
query.getObjectInBackgroundWithId(currentBlockID()) {
(block: PFObject?, error: NSError?) -> Void in
if error != nil {
}
else if let block = block {
let users = block["Users"] as! NSArray
pront(block)
pront(users)
var i = 0
while i < users.count {
var userDict = users[i] as! [String : String]
let userID = userDict["id"]
pront(userDict)
pront(userID!)
if userID == currentParseID() {
pront(currentParseID())
block.removeObject(userDict, forKey: "Users")
block.saveInBackground()
userDict["pictureURL"] = picToConfirm.source
block.addObject(userDict, forKey: "Users")
block.saveInBackground()
}
i += 1
}

}
}
//[{"gender":"male","id":"Ua2ppnURSi","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"},{"gender":"male","id":"F2pL8Y3nBa","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"},{"gender":"male","id":"6LaSRqciQN","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"}]
//[{"gender":"male","id":"Ua2ppnURSi","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"},{"gender":"male","id":"F2pL8Y3nBa","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"},{"gender":"male","id":"6LaSRqciQN","name":"Oliver","pictureURL":"","totalScore":"0","votes":"0"}]
*/


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
/*

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
            //create user object, assign properties
            let user = PFObject(className: "Users")
            user["Facebook_ID"] = result["id"]
            user["Name"] = result["name"]
            user["First_Name"] = result["first_name"]
            user["Email"] = result["email"]
            user["Gender"] = result["gender"]
            user["Location"] = result["locale"]
            user["Picture_URL"] = ""
            user["Total_Score"] = 0
            user["Votes"] = 0
            //set gender preference based on gender
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
            //save iser
            user.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                if (success) {
                    //set the default parse ID, find a user block for the user
                    defaults.setObject(user.objectId, forKey: "Parse_ID")
                }
                else {
                }
                    var query = PFQuery(className: "User_Blocks")
                    query.whereKey("User_Count", lessThanOrEqualTo: 1000)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            // take the first block's id and get it
                            var min = 1800
                            var blockIndex = 0
                            var i = 0
                            let list = objects! as Array
                            while i < list.count {//for block in objects! as Array {
                                let block: AnyObject = list[i]
                                let num = block["Number"] as! Int
                                if num < min {
                                    min = num
                                    blockIndex = i
                                }
                                i += 1
                            }
                            let blockQuery = PFQuery(className: "User_Blocks")
                            let objectID = objects![blockIndex].objectId
                            blockQuery.getObjectInBackgroundWithId(objectID!!) {
                                (block: PFObject?, error: NSError?) -> Void in
                                if error != nil {
                                    pront("error")
                                } else if let block = block {
                                    defaults.setObject(objectID, forKey: "Block_ID")
                                    var userData = [String: String]()
                                    userData = ["name": result["first_name"] as! String, "gender": result["gender"] as! String, "pictureURL": "", "totalScore": "0", "votes": "0", "id": user.objectId! as String]
                                    block.addObject(userData, forKey: "Users")
                                    block.incrementKey("User_Count", byAmount: 1)
                                    block.saveInBackground()
                                }
                            }
                        }
                        else {
                            // Log details of the failure
                        }
                    }
                }
                else {
                }
            }
        })
    }
}*/

/* func returnUserData() {

/*let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

if ((error) != nil)
{
// Process error
println("Error: \(error)")
}
else
{
//println("fetched user: \(result)")
let userName : NSString = result.valueForKey("name") as! NSString
//println("User Name is: \(userName)")
let userEmail : NSString = result.valueForKey("email") as! NSString
//println("User Email is: \(userEmail)")
self.userID = String(result.valueForKey("id") as! NSString)
//println(self.userID)
//println("http://graph.facebook.com/\(self.userID)/picture?type=large")
let url = NSURL(string: "http://graph.facebook.com/\(self.userID)/picture?type=large")
//&width=600&height=600")
let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
self.img = UIImage(data: data!)!
let imgV = UIImageView(image: self.img)
self.view.addSubview(imgV)

if self.defaults.boolForKey("has_account4.0") != true {

let user = PFObject(className: "Users")
user["Facebook_ID"] = self.userID
user["Name"] = userName
user["Email"] = userEmail
user["Gender"] = result.valueForKey("gender") as! NSString
user["Location"] = result.valueForKey("locale") as! NSString
user.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
if (success) {
//println("New user saved.")
//println(String(stringInterpolationSegment: user.objectId))
}
else {
println("Error saving new user.")
}

}

//self.defaults.setBool(true, forKey: "has_account4.0")
}
}
})*/

let graphRequestFriends : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
graphRequestFriends.startWithCompletionHandler({ (connection, result, error) -> Void in

if ((error) != nil)
{
// Process error
println("Error: \(error)")
}
else
{
let friend: AnyObject? = result.valueForKey("data")
let friendID = friend?.valueForKey("name") as! NSArray
//println("Friends: \(friendID[0])")

}
})

/*let graphRequestProfilePicture : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "Profile Pictures/photos", parameters: nil)
graphRequestProfilePicture.startWithCompletionHandler({ (connection, result, error) -> Void in
let coverPhotoID = result.valueForKey("cover_photo") as! NSString
let graphRequestCoverPhoto : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(coverPhotoID)", parameters: nil)
graphRequestCoverPhoto.startWithCompletionHandler({ (connection, result, error) -> Void in

})
})*/

let graphRequestPhotos : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/photos", parameters: nil)
graphRequestPhotos.startWithCompletionHandler({ (connection, result, error) -> Void in

//println("\(result)")

})

let graphRequestAlbums : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/albums", parameters: nil)
graphRequestAlbums.startWithCompletionHandler({ (connection, result, error) -> Void in

func profilePictureAlbumIDFinder(rslt: NSDictionary) -> NSString {
let data = rslt["data"] as! NSArray
for dict in data {
if dict["name"] as! NSString == "Profile Pictures" {
let id = dict["id"] as! NSString
println("\(id)")
}
}

return "fadfad"
}

if ((error) != nil)
{
// Process error
println("Error: \(error)")
}
else
{

let data = result["data"] as! NSArray
for dict in data {
if dict["name"] as! NSString == "Profile Pictures" {
let id = dict["id"] as! NSString
println("\(id)")
}
}
//println("\(data)")

let album: AnyObject? = result.valueForKey("data")
let albumNames = album?.valueForKey("id") as! NSArray
//println("Albums: \(album)")
//println("Albums: \(albumNames)")

let graphRequestPhotos : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(albumNames[0])/photos", parameters: nil)
graphRequestPhotos.startWithCompletionHandler({ (connection, result, error) -> Void in
//println("\(albumNames[0])")
//println("inAlbum \(result)")
/*let cPhotoID = result.valueForKey("cover_photo") as! NSString

let graphRequestCPhotos : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(cPhotoID)", parameters: nil)
graphRequestCPhotos.startWithCompletionHandler({ (connection, result, error) -> Void in
println("inAlbum \(result)")
})*/

})

}
})

}*/

/*let alert = UIAlertController(title: "Error", message: "Not connected to Game Center.", preferredStyle: UIAlertControllerStyle.Alert)
alert.addAction(UIAlertAction(title: "Ok.", style: UIAlertActionStyle.Default, handler: nil))
self.presentViewController(alert, animated: true, completion: nil)*/
