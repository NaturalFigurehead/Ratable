//
//  Methods.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/1/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

func saveRatedUsers() {
    PFCloud.callFunctionInBackground("saveRatings", withParameters: ratedUsers) {
        (response: AnyObject?, error: NSError?) -> Void in
        
        if error == nil {
            ratedUsers = [:]
        }
            
        else {
            
        }
        
    }
}

func getAlbumData() {
    
    if (FBSDKAccessToken.currentAccessToken() != nil) {
        var albumsDidChange = 0 {
            didSet{
                if albumsDidChange == 2 {
                    postNotification("albumSelection")
                }
            }
        }
        albums = []
        let graphRequestMePhotos : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(currentID())/photos", parameters: nil)
        graphRequestMePhotos.startWithCompletionHandler({ (connection, result, error) -> Void in
            let data = result["data"] as! NSArray
            let name = "Photos of You"
            let photoCount = data.count
            let id = "me"
            albums.append(Album(name: name, photos: photoCount, id: id))
            albumsDidChange += 1
        })
        let graphRequestAlbums : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/albums", parameters: ["fields": "count, name, id"])
        graphRequestAlbums.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            let data = result["data"] as! NSArray
            for album in data {
                
                let name = album["name"] as! String
                let photoCount = album["count"] as! Int
                let id = album["id"] as! String
                albums.append(Album(name: name, photos: photoCount, id: id))
                
            }
            albumsDidChange += 1
        })
    }
}

func postNotification(name: String) {
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
}

func customAddObserver(observer: AnyObject, selector: Selector, name: String) {
    NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: nil)
}


func popViewController(note: NSNotification, view: AnyObject) {
    view.removeFromParentViewController()
}

func pront(toPront: AnyObject) {
    print("\(toPront)")
}

func randRange (lower: Int , upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
}

/*func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let c = list.count
    if c < 2 { return list }
    for i in 0..<(c - 1) {
        let j = Int(arc4random_uniform(UInt32(c - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}*/

extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

/*func playVideoAd() {
    var sdk = VungleSDK.sharedSDK()
    sdk.playAd(self, error: nil)
}*/

func vcWithName(name: String) -> UIViewController?
{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier(name)
    return viewController as? UIViewController
}

func openURL(address: String) {
    let url = NSURL(string: address)
    UIApplication.sharedApplication().openURL(url!)
}

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

/*
Show customized activity indicator,
actually add activity indicator to passing view

@param uiView - add activity indicator to this view
*/
func showActivityIndicator(uiView: UIView, isEmbeded: Bool) {
    container.frame = uiView.frame
    if isEmbeded {
        container.center = uiView.center
        container.center.y -= 64
    }
    else {
        container.center = uiView.center
    }
    container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
    
    loadingView.frame = CGRectMake(0, 0, 80, 80)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

/*
Hide activity indicator
Actually remove activity indicator from its super view

@param uiView - remove activity indicator from this view
*/
func hideActivityIndicator(uiView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
}

/*
Define UIColor from hex value

@param rgbValue - hex color value
@param alpha - transparency level
*/
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

func scaleImage(image: UIImage, newSize: CGSize) -> UIImage {
    
    var scaledSize = newSize
    var scaleFactor: CGFloat = 1.0
    
    if image.size.width > image.size.height {
        scaleFactor = image.size.width / image.size.height
        scaledSize.width = newSize.width
        scaledSize.height = newSize.width / scaleFactor
    } else {
        scaleFactor = image.size.height / image.size.width
        scaledSize.height = newSize.height
        scaledSize.width = newSize.width / scaleFactor
    }
    
    UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
    let scaledImageRect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height)
    [image .drawInRect(scaledImageRect)]
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
}

func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
    return RBResizeImage(RBSquareImage(image), targetSize: size)
}

func RBSquareImage(image: UIImage) -> UIImage {
    let originalWidth  = image.size.width
    let originalHeight = image.size.height
    
    var edge: CGFloat
    if originalWidth > originalHeight {
        edge = originalHeight
    } else {
        edge = originalWidth
    }
    
    let posX = (originalWidth  - edge) / 2.0
    let posY = (originalHeight - edge) / 2.0
    
    let cropSquare = CGRectMake(posX, posY, edge, edge)
    
    let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
    return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
}

func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.mainScreen().scale)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func displayAlertView(title: String, message: String, action: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func displayRatingRequest(viewController: UIViewController) {
    let alert = UIAlertController(title: "Howdy!", message: "I hope you're enjoying Ratable. Would you pretty please give it a rating on the app store? It would make me very happy.", preferredStyle: UIAlertControllerStyle.Alert)

    let sureAction = UIAlertAction(title: "Sure", style: .Default) { (action) in
        
        defaults.setObject("true", forKey: "Rating")
        
        goToURL("https://itunes.apple.com/us/app/ratable/id1025633125?ls=1&mt=8")
        
        buttonEvent("Rate Request", button: "Yes")
        
    }
    alert.addAction(sureAction)
    
    let laterAction = UIAlertAction(title: "Later", style: .Default) { (action) in
        
        buttonEvent("Rate Request", button: "Later")
        
    }
    
    alert.addAction(laterAction)
    
    let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
        
        defaults.setObject("true", forKey: "Rating")
        
        buttonEvent("Rate Request", button: "Yes")
        
    }
    alert.addAction(noAction)
    
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func displayShareRequest(viewController: UIViewController) {
    let alert = UIAlertController(title: "Howdy!", message: "I hope you're enjoying Ratable. Would you pretty please share it with your friends? It would make me very happy.", preferredStyle: UIAlertControllerStyle.Alert)
    
    let sureAction = UIAlertAction(title: "Share", style: .Default) { (action) in
        
        defaults.setObject("true", forKey: "Share")
        
        socialShare(viewController)
        
        buttonEvent("Share Request", button: "Yes")
        
    }
    alert.addAction(sureAction)
    
    let laterAction = UIAlertAction(title: "Later", style: .Default) { (action) in
        
        buttonEvent("Share Request", button: "Later")
        
    }
    
    alert.addAction(laterAction)
    
    let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
        
        defaults.setObject("true", forKey: "Share")
        
        buttonEvent("Share Request", button: "No")
        
    }
    alert.addAction(noAction)
    
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func socialShare(viewController: UIViewController) {
    var sharingItems = [AnyObject]()
    
    //sharingItems.append("")
    let url = NSURL(string: "https://itunes.apple.com/us/app/ratable/id1025633125?ls=1&mt=8")
    sharingItems.append(url!)
    
    let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
    activityViewController.popoverPresentationController?.sourceView = viewController.view
    viewController.presentViewController(activityViewController, animated: true, completion: nil)
}

func goToURL(url: String) {
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
}

func buttonEvent(location: String, button: String) {
    let dimensions = [location: button]
    PFAnalytics.trackEvent("Action", dimensions: dimensions)
}
