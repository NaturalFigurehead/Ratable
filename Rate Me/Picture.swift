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
        if image == nil {
            let url =  NSURL(string: "https://ratable.files.wordpress.com/2015/08/logo.png?w=544")
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            self.image = image!
        }
        else {
            self.image = image!
        }
        self.id = id
        super.init()
    }

}
