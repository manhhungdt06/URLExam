//
//  CustomTextField.swift
//  NSURLSession
//
//  Created by Vinh The on 7/27/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = UIFont.init(name: "OpenSans-Light", size: 18.0)
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 248/255, green: 116/255, blue: 98/255, alpha: 1.0).CGColor
        switch tag {
        case 101:
            configurePlaceholder("Name")
        case 102:
            configurePlaceholder("Phone Number")
        case 103:
            configurePlaceholder("City")
        case 104:
            configurePlaceholder("Email")
        default:
            break
        }
        
        
    }
    
    func configurePlaceholder(content : String) {
        let attribute = [NSFontAttributeName : UIFont.init(name: "OpenSans-Light", size: 18.0)!, NSForegroundColorAttributeName : UIColor.blackColor()]
        
        attributedPlaceholder = NSAttributedString(string: content, attributes: attribute)
    }

}
