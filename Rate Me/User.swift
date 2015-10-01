//
//  User.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/23/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String
    var image: UIImage
    var id: String
    var score: Double
    var votes: Double
    
    init(name: String, source: String, id: String, totalVotes: Int, totalScore: Int) {
        self.votes = Double(totalVotes)
        self.name = name
        if id == "empty" {
            self.image = UIImage(named: "Circle")!
        }
        else {
           let url =  NSURL(string: source)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            self.image = image!
        }
        
        self.id = id
        let total = totalScore
        let votes = totalVotes
        if votes == 0 {
            self.score = 0.0
        }
        else {
            let score: Int =  10 * (total / votes)
            let newScore: Double = Double(score) / 10
            self.score = newScore
        }
        super.init()
    }
    
    init(object: PFObject) {
        self.votes = object["votes"] as! Double
        self.name = object["first_Name"] as! String
        let picURL = object["picture_url"] as! String
        let url =  NSURL(string: picURL)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        self.image = image!
        self.id = object.objectId!
        self.score = object["total_score"] as! Double
        super.init()
    }
    
    init(user: SmallUser) {
        self.votes = Double(user.votes)
        self.name = user.name
        var picURL = user.image
        picURL = picURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: picURL)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        if image == nil {
            let url =  NSURL(string: "https://ratable.files.wordpress.com/2015/08/logo.png?w=544")
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            self.image = image!
        }
        else {
            self.image = image!
        }
        self.id = user.id
        self.score = Double(user.totalScore)
        super.init()
    }
}
