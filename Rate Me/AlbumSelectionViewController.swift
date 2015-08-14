//
//  AlbumSelectionViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/26/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class AlbumSelectionViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popViewController:", name: "picSaved", object: nil)
        if !profilePicIsSet() {
            displayAlertView("Welcome!", "On Ratable other users will see your picture and rate your looks 1-10. You do the same for them. Now pick a selfie from Facebook to be your profile picture.", "Ok", self)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath)
                as! UITableViewCell
            let album = albums[indexPath.row] as Album
            cell.textLabel?.text = album.name
            cell.detailTextLabel?.text = "\(album.photos)"
            return cell
            
    }
    
    var picturesDidChange = false {
        didSet{
            if picturesDidChange {
                self.performSegueWithIdentifier("ASVC to PSVC", sender: self)
                hideActivityIndicator(self.view)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        showActivityIndicator(self.view, true)
        
        let selectedAlbum = albums[indexPath.row] as Album
        getPicturesForAlbum(selectedAlbum.id)
        
    }
    
    func getPicturesForAlbum(id: String) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            pictures = []
            let graphRequestAlbums : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(id)/photos", parameters: ["fields": "images, id"])
            graphRequestAlbums.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                pront(result)
                
                let data = result["data"] as! NSArray
                for photo in data {
                    let images = photo["images"] as! NSArray
                    let id = photo["id"] as! String
                    let picture = Picture(source: images[0]["source"] as! String, id: id)
                    pictures.append(picture)
                    /*for size in images {
                        if size["height"] as! Int >= 130 {
                            let picture = Picture(source: size["source"] as! String, id: id)
                            pictures.append(picture)
                        }
                    }*/
                    
                }
                self.picturesDidChange = true
                
            })
        }
    }
    
    func popViewController(note: NSNotification) {
        self.removeFromParentViewController()
    }
    
}