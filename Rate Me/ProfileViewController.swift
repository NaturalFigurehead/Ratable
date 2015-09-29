//
//  ProfileViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/4/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit
import Social

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var personalScore: UILabel!
    @IBOutlet weak var dataTable: UITableView!
    @IBAction func fbAction(sender: UIButton) {
        buttonEvent("Profile", button: "Facebook Share")
        showFaceSheet()
    }
    @IBAction func twAction(sender: AnyObject) {
        buttonEvent("Profile", button: "Twitter Share")
        showTweetSheet()
    }
    @IBAction func changePicture(sender: UIButton) {
        buttonEvent("Profile", button: "Change Picture")
        getAlbumData()
    }
    
    override func viewDidLoad() {
        self.dataTable.dataSource = self
        self.dataTable.delegate = self
        let profilePicture = Picture(source: currentProfilePic(), id: "")
        let profileImage = RBSquareImage(profilePicture.image)
        self.imageView.image = profileImage
        self.personalScore.text = ""
        let total = Double(currentUser["Total_Score"]!)
        let votes = Double(currentUser["Votes"]!)
        if votes == 0.0 {
            self.personalScore.text = "0.0"
        }
        else {
            let score: Int =  Int(10 * (total / votes))
            let newScore: Double = Double(score) / 10
            if newScore == 10.0 {
                self.personalScore.text = "10"
            }
            else {
                self.personalScore.text = "\(newScore)"
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath)
            as! ProfileCell
        switch indexPath.row {
        case 0:
            cell.titleLabel?.text = "Your selfie was voted on"
            let votes: Int = currentUser["Votes"]!
            cell.dataLabel?.text = "\(votes) times"
        case 1:
            cell.titleLabel?.text = "It is in the top"
            var value: Double = 100 * cuRank
            value = round(10 * value) / 10
            cell.dataLabel?.text = "\(value)%"
        case 2:
            cell.titleLabel?.text = "It was rated 10"
            let value: Int = currentUser["n10"]!
            cell.dataLabel?.text = "\(value) times"
        case 3:
            cell.titleLabel?.text = "On average you rated others"
            let total = Double(currentUser["Total_Score_Given"]!)
            let votes = Double(currentUser["Votes_Given"]!)
            var average = Double()
            if votes != 0.0 {
                average = total / votes
                average = round(10 * average) / 10
            }
            else {
                average = 0
            }
            cell.dataLabel?.text = "\(average)"
        case 4:
            cell.titleLabel?.text = "You voted"
            let value: Int = currentUser["Votes_Given"]!
            cell.dataLabel?.text = "\(value) times"
        case 5:
            cell.titleLabel?.text = "You tend to rate others"
            let total = cuScoreDif
            let votes = Double(currentUser["Votes_Given"]!)
            var average = Double()
            if votes != 0.0 {
                average = total / votes
                average = round(10 * average) / 10
                if average < 0 {
                    cell.dataLabel?.text = "\(-average) lower"
                }
                else {
                    cell.dataLabel?.text = "\(average) higher"
                }
            }
            else {
                cell.dataLabel?.text = "not at all"
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func showTweetSheet() {
        let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                buttonEvent("Profile", button: "Twitter Success")
                break
            }
        }
        
        tweetSheet.setInitialText("Test Twitter") //The default text in the tweet
        //tweetSheet.addImage(UIImage(named: "TestImage.png")) //Add an image if you like?
        tweetSheet.addURL(NSURL(string: "http://twitter.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(tweetSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    func showFaceSheet() {
        let faceSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        faceSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                buttonEvent("Profile", button: "Facebook Success")
                break
            }
        }
        
        faceSheet.setInitialText("") //The default text in the tweet
        //tweetSheet.addImage(UIImage(named: "TestImage.png")) //Add an image if you like?
        faceSheet.addURL(NSURL(string: "http://twitter.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(faceSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    /*var albumsDidChange = 0 {
        didSet{
            if albumsDidChange == 2 {
                albumsDidChange = 0
                self.presentViewController(vcWithName("ASVC")!, animated: true, completion: nil)
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

}
