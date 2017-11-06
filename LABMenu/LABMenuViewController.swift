//
//  File.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

open class LABMenuViewController: UIViewController, UIGestureRecognizerDelegate, LABMenuContainerDelegate {
    
    open var type: AnyClass! {
        return LABMenuViewController.self
    }
    open var menuView: LABMenuView!
    open var internalNavigationController: UINavigationController!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        menuView = LABMenuView(mainColor: UIColor.gray,
                            tint: UIColor.white)
        
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        self.navigationController!.navigationBar.backgroundColor = menuView.mainColor
        
        self.view.addSubview(menuView)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuView.alpha = 1
    }
    
    public func setMenuButton(image: UIImage) {
        let menuButton: UIBarButtonItem = UIBarButtonItem.barButton(nil,
                                                                    image: image,
                                                                    titleColor: menuView.tint,
                                                                    font: UIFont.systemFont(ofSize: 12),
                                                                    inContext: self,
                                                                    selector: #selector(LABMenuViewController.toggleLeft))
        setMenuButton(button: menuButton)
    }
    
    public func setMenuButton(button: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.leftBarButtonItem!.tintColor = menuView.tint
    }
    
    private func addBackButton() {
        if self.navigationItem.rightBarButtonItem != nil {
            return
        }
        
        let backButton = UIBarButtonItem.barButton(nil,
                                                   image: nil,
                                                   titleColor: menuView.tint,
                                                   font: UIFont.systemFont(ofSize: 12),
                                                   inContext: self,
                                                   selector: #selector(LABMenuViewController.onBackClick))
        self.navigationItem.rightBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem!.tintColor = menuView.tint
    }
    
    private func removeBackButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if internalNavigationController == nil {
            internalNavigationController = UINavigationController(rootViewController: viewController)
            
            addChildViewController(internalNavigationController)
            internalNavigationController.view.frame = self.view.bounds
            self.view.addSubview(internalNavigationController.view)
            internalNavigationController.didMove(toParentViewController: self)
            
            self.view.bringSubview(toFront: menuView)
        } else {
            
            for queueViewController in internalNavigationController.viewControllers
                where object_getClassName(queueViewController) == object_getClassName(viewController)
            {
                return
            }
            
            internalNavigationController.pushViewController(viewController, animated: animated)
            addBackButton()
        }
    }
    
    /**
     Triggered when back button is clicked.
     */
    @objc open func onBackClick() {
        internalNavigationController.popViewController(animated: true)
        
        if internalNavigationController.viewControllers.count == 1 {
            removeBackButton()
        }
    }
    
    @objc open func toggleLeft() {
        if menuView.isShowing {
            menuView.hide()
        } else {
            menuView.show()
        }
    }
    
    open func selectItemAt(indexPath: IndexPath) {
        NSLog("item selected at section: \(indexPath.section),and row: \(indexPath.row)")
    }
}
