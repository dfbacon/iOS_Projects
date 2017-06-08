//
//  ModificationTextField.swift
//  Social
//
//  Created by Daniel Bacon on 6/8/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

class ModificationTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Define border
        layer.borderColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
    }

    // Impacts placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {

        // dx and dy are the axis
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    // Impacts edited text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
