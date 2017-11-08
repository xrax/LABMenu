//
//  Extensions.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

extension UIBarButtonItem {
    static func barButton(_ title: String?,
                         image: UIImage?,
                         titleColor: UIColor,
                         font: UIFont,
                         inContext context: UIViewController,
                         selector: Selector) -> UIBarButtonItem
    {
        let internalButton = UIButton(type: UIButtonType.custom)
        var lbTitle = title
        
        if title == nil {
            lbTitle = "<"
        } else {
            lbTitle = "< " + title!
        }
        
        // Configuración del botón
        
        if image != nil {
            internalButton.setImage(image, for: UIControlState())
        } else {
            internalButton.frame = CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
            internalButton.backgroundColor = UIColor.clear
            internalButton.setTitle(lbTitle, for: UIControlState())
            internalButton.setTitleColor(titleColor, for: UIControlState())
            internalButton.titleLabel?.textAlignment = NSTextAlignment.left
            internalButton.titleLabel?.sizeToFit()
            internalButton.titleLabel?.font = font
            internalButton.sizeToFit()
        }
        internalButton.addTarget(context, action: selector, for: UIControlEvents.touchDown)
        
        return UIBarButtonItem.init(customView: internalButton)
    }
}
