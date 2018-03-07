//
//  RoundTextFiled.swift
//  served
//
//  Created by firebase on 10/7/17.
//  Copyright © 2017 firebase.team. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextFiled: UITextField {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
