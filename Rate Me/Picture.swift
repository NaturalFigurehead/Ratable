//
//  Picture.swift
//  Rate Me
//
//  Created by Oliver Reznik on 6/29/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

import UIKit

class Picture: NSObject {
    
    var source: String
    var image: UIImage
    var id: String
    
    init(source: String, id: String) {
        self.source = source
        let url =  NSURL(string: source)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        self.image = image!
        self.id = id
        super.init()
    }

}
