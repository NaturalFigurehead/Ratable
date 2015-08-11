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
    }
    
    func displayAlbumSelection(note: NSNotification) {
        if currentVC == 1 {
            self.performSegueWithIdentifier("MPVC to ASVC", sender: self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /*if !viewWasSelected {
            if self.scrollView.contentOffset.x < (self.view.frame.width / 2){
                self.segmentedControl.selectedSegmentIndex = 0
            }
            else {
                self.segmentedControl.selectedSegmentIndex = 1
            }
        }*/
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        //pront(viewWasSelected)
        //viewWasSelected = false
    }
    
    func popViewController(note: NSNotification) {
        self.removeFromParentViewController()
    }

}
