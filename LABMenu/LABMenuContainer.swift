//
//  MenuContainer.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

public protocol LABMenuContainerDelegate {
    func selectItemAt(indexPath: IndexPath)
}

open class LABMenuContainer: UIView {
    open var delegate: LABMenuContainerDelegate
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(delegate: LABMenuContainerDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: LABMenuView.LABMenuOptions.width,
                                 height: UIScreen.main.bounds.height))
    }
}
