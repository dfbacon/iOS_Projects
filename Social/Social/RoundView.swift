//
//  RoundView.swift
//  Social
//
//  Created by Daniel Bacon on 6/9/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class RoundView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        layer.cornerRadius = self.frame.width / 2
//    }

}
