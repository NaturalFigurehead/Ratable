//
//  PictureSelectionViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/23/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class PictureSelectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popViewController:", name: "picSaved", object: nil)
    }
    
    private let reuseIdentifier = "PictureCell"
    //private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PictureCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        let photo = pictures[indexPath.row] as Picture
        cell.imageView.image = RBSquareImageTo(photo.image, size: bestSize)
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let screen: CGRect = UIScreen.mainScreen().bounds
            let cellWidth = (screen.width / 2) - 10
            let size = CGSizeMake(cellWidth, cellWidth)
            return size
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        picToConfirm = pictures[indexPath.row] as Picture
        imgToConfirm = picToConfirm.image
        self.performSegueWithIdentifier("PSVC to PCVC", sender: self)
    }
    
    func popViewController(note: NSNotification) {
        self.removeFromParentViewController()
    }
    
}
