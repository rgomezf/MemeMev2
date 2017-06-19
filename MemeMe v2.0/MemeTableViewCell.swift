//
//  MemeTableViewCell.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 6/14/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Founded aproach on the forums.  Previously couldn't display the images correctly.
        
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        self.textLabel?.frame = CGRect(x: 130, y: 45, width: 245, height: 30)
    }
}
