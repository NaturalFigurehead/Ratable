//
//  AppDelegate.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/16/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("7UwhtazcuevDkp5mhdGGfZ9ufpjvdENWgVP5COCs",
            clientKey: "mHdITsCr87xvISQQkCHxcWaCoeVjylgUfuJQKjiW")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Parse Facebook
        //PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        var appID = "55b7ec37d0f6ab4c44000096"
        var sdk = VungleSDK.sharedSDK()
        // start vungle publisher library
        sdk.startWithAppId(appID)
        
        //in app purchase made
        PFPurchase.addObserverForProduct("ratable.removeads") {
            (transaction: SKPaymentTransaction?) -> Void in
            // Write business logic that should run once this product is purchased.
            defaults.setObject("true", forKey: "Ads_Removed")
            defaults.synchronize()
        }
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } /*else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }*/
        
        
        
        
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //if current user was altered during user then save changes
        if voteCount > 0 || picChanged {
            
            //increment keys and update picture before saving
            let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: scoreID)
            user.incrementKey("votes_given", byAmount: voteCount)
            user.incrementKey("score_given", byAmount: scoreCount)
            user.incrementKey("score_difference", byAmount: scoreDifCount)
            user["picture_url"] = currentProfilePic()
            user.saveInBackground()
            
            //revert to base values
            voteCount = 0
            scoreCount = 0
            scoreDifCount = 0
            picChanged = false
        }
        
        if ratedUsers.count > 0 {
            saveRatedUsers()
        }

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()

    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        //if current user was altered during user then save changes
        if voteCount > 0 || picChanged {
           
            
            //increment keys and update picture before saving
            let user = PFObject(withoutDataWithClassName: "Score_Data", objectId: scoreID)
            user.incrementKey("votes_given", byAmount: voteCount)
            user.incrementKey("score_given", byAmount: scoreCount)
            user.incrementKey("score_difference", byAmount: cuScoreDif)
            user["picture_url"] = currentProfilePic()
            user.saveInBackground()
            
            //revert to base values
            voteCount = 0
            scoreCount = 0
            scoreDifCount = 0
            picChanged = false
        }
        
        if ratedUsers.count > 0 {
            PFCloud.callFunctionInBackground("saveRatings", withParameters: ratedUsers) {
                (response: AnyObject?, error: NSError?) -> Void in
                
                if error == nil {
                    ratedUsers = [:]
                }
                    
                else {
                }
                
            }
        }
        
        pront("shut")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
}

