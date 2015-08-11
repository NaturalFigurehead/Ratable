//
//  Album.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/26/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class Album: NSObject {

    var name: String
    var photos: Int
    var id: String
    
    init(name: String, photos: Int, id: String) {
        self.name = name
        self.photos = photos
        self.id = id
        super.init()
    }
    
}
