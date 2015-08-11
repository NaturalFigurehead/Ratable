//
//  smallUser.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/28/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class SmallUser: NSObject {
    var name: String
    var image: String
    var id: String
    var totalScore: Int
    var votes: Int
    init(object: PFObject) {
        self.votes = object["votes"] as! Int
        self.name = object["first_name"] as! String
        self.image = object["picture_url"] as! String
        self.id = object.objectId!
        self.totalScore = object["total_score"] as! Int
        super.init()
    }
}
