//
//  LoadingViewController.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/29/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add login button view
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_photos"]
        loginView.delegate = self
        
    }
    
    // login button pressed
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
            if result.grantedPermissions.contains("user_photos") && result.grantedPermissions.contains("public_profile"){
                // Do work
                self.login()
            }
            else {
                displayAlertView("Oops", "Ratable needs access to your public profile and photos. Please make sure to allow access to those things.", "Ok", self)
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            
            //sign up / login
            
            
        }
    }
    
    //logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOut()
    }
    
    //sign up via cloud code
    func login() {
        
        //check if logged into facebook
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            //access facebook profile info
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, email, name, gender"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                //define properties
                let id = result["id"] as! String
                let name = result["name"] as! String
                let email = result["email"] as! String
                let firstName = result["first_name"] as! String
                let gender = result["gender"] as! String
                
                //set facebook id
                defaults.setValue(id, forKey: "Facebook_ID")
                
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
                
                //compile into parameter dicionary
                let userData: [String:String] = ["id": id, "name": name, "email": email, "firstName": firstName, "gender": gender]
                
                //call cloud sign up function
                PFCloud.callFunctionInBackground("newUser", withParameters: userData) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    
                    //success
                    if error == nil {
                        
                        //let indexString = response as! String
                        //maximumIndex = indexString.toInt()!
                        
                        //login user
                        PFUser.logInWithUsernameInBackground(id, password: id) {
                            (user: PFUser?, error: NSError?) -> Void in
                            
                            if error == nil {
                                
                                //unpin then save current user
                                PFObject.unpinAllObjectsInBackgroundWithName("Current_User")
                                user!.pinInBackgroundWithName("Current_User")
                                
                                //picture is not set
                                defaults.setBool(false, forKey: "Picture_Is_Set")
                                
                                //unpin current to rate stuff
                                PFObject.unpinAllObjectsInBackgroundWithName("To_Rate")
                                PFObject.unpinAllObjectsInBackgroundWithName("Rated")
                                
                                //move back to view controller
                                self.performSegueWithIdentifier("LVC to VC", sender: self)
                                
                            } else {
                                // The login failed. Check error to see why.
                                displayAlertView("Sorry", "There was an error signing up. Please try again later.", "Ok", self)
                                let loginManager = FBSDKLoginManager()
                                loginManager.logOut()
                            }
                        }
                        
                    }
                        //error
                    else {
                        
                        //interpret the error code
                        let code = String(stringInterpolationSegment: error)
                        pront(code)
                        
                        //if username taken, login
                        //if code == "202" {
                            
                            //login user
                            PFUser.logInWithUsernameInBackground(id, password: id) {
                                (user: PFUser?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    
                                    //unpin then save current user
                                    PFObject.unpinAllObjectsInBackgroundWithName("Current_User")
                                    user!.pinInBackgroundWithName("Current_User")
                                    
                                    //move back to view controller
                                    self.performSegueWithIdentifier("LVC to VC", sender: self)
                                    
                                }
                                else {
                                    // The login failed. Check error to see why.
                                    displayAlertView("Sorry", "There was an error logging in. Please try again later.", "Ok", self)
                                    let loginManager = FBSDKLoginManager()
                                    loginManager.logOut()
                                }
                            }
                        //}
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
