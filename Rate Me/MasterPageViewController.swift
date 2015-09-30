//
//  MasterPageViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/28/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class MasterPageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        //viewWasSelected = true
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.scrollView.setContentOffset(CGPointMake(0, -64), animated: false)
        case 1:
            self.scrollView.setContentOffset(CGPointMake(self.view.frame.width, -64), animated: false)
        default:
            break; 
        }
    }
    @IBAction func logoButton(sender: UIBarButtonItem) {
        goToURL("http://ratableapp.com/")
        buttonEvent("Master", button: "Logo")
        //self.presentViewController(vcWithName("TNC")!, animated: true, completion: nil)
    }
    
    
    //var viewWasSelected = false
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popViewController:", name: "picSaved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayAlbumSelection:", name: "albumSelection", object: nil)
        currentVC = 1
        
        self.scrollView.delegate = self
        if fromPicConfirm {
            self.segmentedControl.selectedSegmentIndex = 0
            self.scrollView.setContentOffset(CGPointMake(0, -64), animated: false)
            fromPicConfirm = false
        }
        else {
            self.scrollView.setContentOffset(CGPointMake(self.view.frame.width, -64), animated: false)
        }
        
        //increment session count
        if !(sessionCount() > 0) {
            displayAlertView("Hello", message: "It's time to rate a pet's cuteness. Give it a score using the orange slider below. When you have it picked out press the green check mark. When you're done press the blue arrow to move on to the next picture.", action: "Ok", viewController: self)
            defaults.setInteger(1, forKey: "Sessions")
        }
        else {
            defaults.setInteger(sessionCount() + 1, forKey: "Sessions")
        }
        
        let profile = vcWithName("Profile")!
        profile.view.frame.origin.y -= 64
        self.addChildViewController(profile)
        self.scrollView.addSubview(profile.view)
        profile.didMoveToParentViewController(self)
        
        let rate = vcWithName("Rate")!
        var frame = rate.view.frame
        frame.origin.x = self.view.frame.size.width
        frame.origin.y -= 64
        rate.view.frame = frame
        self.addChildViewController(rate)
        self.scrollView.addSubview(rate.view)
        rate.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 64)
        
        //request rating or share
        if sessionCount() % 2 == 0 && sessionCount() > 3 {
            if requestedRating() == "false" {
                displayRatingRequest(self)
            }
        }
        else if sessionCount() > 3 {
            if requestedShare() == "false" {
                displayShareRequest(self)
            }
        }

    }
    
    func displayAlbumSelection(note: NSNotification) {
        if currentVC == 1 {
            self.performSegueWithIdentifier("MPVC to ASVC", sender: self)
        }
    }
    
    func popViewController(note: NSNotification) {
        self.removeFromParentViewController()
    }
    
    override  func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        //return UIInterfaceOrientation.Portrait.rawValue
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
