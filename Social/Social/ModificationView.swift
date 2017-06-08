//
//  ModificationView.swift
//  Social
//
//  Created by Daniel Bacon on 6/8/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class ModificationView: UIView {

    // Add shadow/depth to header
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // SHADOW_GRAY defined as global constant in Constants.swift
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8

        // How far the shadow expands out
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }
}
