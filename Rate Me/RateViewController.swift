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
    @IBOutlet weak var shadowView: UIView!
    
    //slider moved
    @IBAction func sliderAction(sender: UISlider) {
        score = Int(sender.value)
        youScore.text = "\(score)"
        if checked && score >= 9 {
            scoreView.backgroundColor = avgScoreBG.tintColor
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
        
        //check to display ad
        if adsRemoved() == "false" {
            if (userNum + 1) % adFrequency == 0 {
                //var sdk = VungleSDK.sharedSDK()
                //sdk.playAd(self, error: nil)
            }
        }
        
        //if there are enough users loaded
        if picsLoaded && userCount - 2 > userNum {
            
            //usersToRate[userNum] = User(name: "", source: "", id: "empty", totalVotes: 0, totalScore: 0)
            
            let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: usersToRate[userNum].id)
            user.unpinInBackgroundWithName("To_Rate")
            user.pinInBackgroundWithName("Rated")
            
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
                
                if ratedUsers.count >= saveRate {
                    saveRatedUsers()
                }
                
                buttonEvent("Rate", "Rate")
                
            }
            self.score = 5
            self.youScore.text = String(score)
            self.slider.value = 5
            self.checked = false
            userNum += 1
            
            self.addUser()
            
            
            buttonEvent("Rate", "Next")
            
        }
        else {
            showActivityIndicator(self.imageView, false)
            buttonEvent("Rate", "Buffer")
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
            if average != 10 {
                self.avgScore.text = String(stringInterpolationSegment: average)
            }
            else {
                self.avgScore.text = "10"
            }
            
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
            self.imageView.image = RBSquareImage(usersToRate[userNum].image)
            self.backImageView.image = RBSquareImage(usersToRate[userNum + 1].image)
        }

        let length = (self.view.frame.height * (2 / 3)) - 80
        
        self.shadowView.backgroundColor = UIColor.clearColor()
        self.shadowView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.shadowView.layer.shadowPath = UIBezierPath(roundedRect: CGRectMake(0, 0, length, length), cornerRadius: 10.0).CGPath
        self.shadowView.layer.shadowOffset = CGSizeMake(0, 3)
        self.shadowView.layer.shadowOpacity = 1
        self.shadowView.layer.shadowRadius = 3
        self.shadowView.layer.masksToBounds = true
        self.shadowView.clipsToBounds = false
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
            queueMoreUsers()
        }
    }
    
    
    func runRateAnimation() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.avgScoreView.center.y -= self.avgScoreView.bounds.height
            self.avgScoreBG.center.y -= self.avgScoreBG.bounds.height
            //self.youScore.textColor = UIColor.whiteColor()
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
            //self.youScore.textColor = self.avgScore.tintColor
            self.scoreBG.frame.size.width = 0
            self.scoreBG.center.x = self.view.frame.size.width / 2
            self.scoreView.backgroundColor = UIColor.whiteColor()
            
            }, completion: { (finished:Bool) -> () in
                self.imageView.image = RBSquareImage(usersToRate[userNum].image)
                self.imageView.alpha = 1
                self.backImageView.image = RBSquareImage(usersToRate[userNum + 1].image)
        })
    }
    
    
    
    
    
    
}


