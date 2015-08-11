//
//  RateViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/7/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit
import Bolts

class RateViewController: UIViewController {
    
    
    var score = 5
    var checkedScore = 5
    var scoreDifference: Double = 0
    var checked = false
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var youScore: UILabel!
    @IBOutlet weak var scoreBG: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var avgScore: UILabel!
    @IBOutlet weak var avgScoreView: UIView!
    @IBOutlet weak var avgScoreBG: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageBorder: UIView!
    
    //slider moved
    @IBAction func sliderAction(sender: UISlider) {
        score = Int(sender.value)
        youScore.text = "\(score)"
        if checked && score >= 9 {
            scoreView.backgroundColor = slider.thumbTintColor
        }
    }
    
    //swipe on picture
    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        nextUser()
    }
    
    //next button
    @IBAction func nextAction(sender: UIButton) {
        nextUser()
    }
    
    //moving to next user
    func nextUser() {
        pront(userNum)
        pront(adFrequency)
        pront((userNum + 1) % adFrequency)
        
        //check to display ad
        if adsRemoved() == "false" {
            if (userNum + 1) % adFrequency == 0 {
                //var sdk = VungleSDK.sharedSDK()
                //sdk.playAd(self, error: nil)
            }
        }
        
        //if there are enough users loaded
        if picsLoaded && userCount - 2 > userNum {
            
            let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: usersToRate[userNum].id)
            user.unpinInBackgroundWithName("To_Rate")
            user.pinInBackgroundWithName("Rated")
            
            userNum += 1
            self.addUser()
            reverseRateAnimation()
            
            if checked {
                
                //update count trackers for user ratings
                voteCount += 1
                scoreCount += checkedScore
                scoreDifCount += scoreDifference
                
                //increment current user dictionary values
                currentUser["Votes_Given"]! += 1
                currentUser["Total_Score_Given"]! += checkedScore
                cuScoreDif += scoreDifference
                
                //save scores for the rated user
                ratedUsers[usersToRate[userNum].id] = String(score)
                
            }
            self.score = 5
            self.youScore.text = String(score)
            self.slider.value = 5
            self.checked = false
        }
        else {
            showActivityIndicator(self.imageView, false)
        }
    }
    
    @IBAction func checkAction(sender: UIButton) {
        
        //runanimation
        if !checked {
            
            checkedScore = score
            
            //calculate avg
            let user = usersToRate[userNum]
            var average = Double()
            if user.votes != 0.0 {
                average = (user.score) / (user.votes)
                average = round(10 * average) / 10
            }
            else {
                average = 0
            }
            self.avgScore.text = String(stringInterpolationSegment: average)
            scoreDifference = Double(checkedScore) - average
            
            runRateAnimation()
        }
        checked = true
    }
    
    override func viewDidLoad() {
        //format displayed picture
        self.youScore.text = "5"
        self.avgScoreView.center.y += self.avgScoreView.frame.height
        self.avgScoreBG.center.y += self.avgScoreBG.frame.height
        //self.avgScore.text = String(stringInterpolationSegment: usersToRate[userNum].score)
        self.imageBorder.layer.cornerRadius = 10.0
        self.imageBorder.clipsToBounds = true
        self.imageView.layer.cornerRadius = 10.0
        self.imageView.clipsToBounds = true
        self.backImageView.layer.cornerRadius = 10.0
        self.backImageView.clipsToBounds = true
        if usersToRate.count > 2 {
            self.imageView.image = usersToRate[userNum].image
            self.backImageView.image = usersToRate[userNum + 1].image
        }
    }
    
    func addUser() {
        
        //if there are enough small users
        if smallUsersToRate.count > 10 + userNum {
            
            //add a new user to user to rate
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                let userToRate = User(user: smallUsersToRate[9 + userNum])
                usersToRate.append(userToRate)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    pront("Count: \(usersToRate.count)")
                    userCount += 1
                    hideActivityIndicator(self.imageView)
                    
                }
            }
            
        }
        else {
            queueUsers()
        }
    }
    
    
    func runRateAnimation() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.avgScoreView.center.y -= self.avgScoreView.bounds.height
            self.avgScoreBG.center.y -= self.avgScoreBG.bounds.height
            self.youScore.textColor = UIColor.blackColor()
            self.scoreBG.frame.size.width = self.view.frame.size.width
            self.scoreBG.center.x = self.view.frame.size.width / 2
            }, completion: nil)
    }
    
    func reverseRateAnimation() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            
            self.imageView.alpha = 0
            if self.checked {
                self.avgScoreView.center.y += self.avgScoreView.bounds.height
                self.avgScoreBG.center.y += self.avgScoreBG.bounds.height
            }
            self.youScore.textColor = self.slider.minimumTrackTintColor
            self.scoreBG.frame.size.width = 0
            self.scoreBG.center.x = self.view.frame.size.width / 2
            self.scoreView.backgroundColor = UIColor.blackColor()
            
            }, completion: { (finished:Bool) -> () in
                self.imageView.image = usersToRate[userNum].image
                self.imageView.alpha = 1
                self.backImageView.image = usersToRate[userNum + 1].image
        })
    }
    
    
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
    
    
    
}


