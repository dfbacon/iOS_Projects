//
//  RoundBtn.swift
//  Social
//
//  Created by Daniel Bacon on 6/8/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit

        // Partially round corners
        // layer.cornerRadius = 5.0
    }

    // Rounded corners for circle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // frame size has been determined at this point
        layer.cornerRadius = self.frame.width / 2
    }
    
}
