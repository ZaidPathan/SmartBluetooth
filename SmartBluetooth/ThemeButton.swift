//
//  ThemeButton.swift
//  Web To RK Template
//
//  Created by Zaid Pathan on 22/08/17.
//  Copyright © 2017 Applied Informatics. All rights reserved.
//

import UIKit

@IBDesignable class ThemeButton: UIButton {
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor() {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 1.0 {
        didSet{
            layer.shadowRadius = shadowRadius
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 1.0 {
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var masksToBound: Bool = false {
        didSet {
            layer.masksToBounds = masksToBound
        }
    }
    
}
