//
//  File.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

open class LABMenuViewController: UIViewController, UIGestureRecognizerDelegate, LABMenuContainerDelegate, LABMenuViewDelegate {
    
    open var type: AnyClass! {
        return LABMenuViewController.self
    }
    open var menuView: LABMenuView!
    open var internalNavigationController: UINavigationController!
    open var barColor = UIColor.gray
    open var barTintColor = UIColor.white
    open var menuProportionalWidth: NSNumber?
    open var hideMenuButtonWhenShow: Bool = false
    private var handlerView: UIView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // menuView Settings
        var widthMenu: CGFloat?
        let proportionalWidth = menuProportionalWidth as? CGFloat
        if proportionalWidth != nil && proportionalWidth! >= 0 && proportionalWidth! <= 1 {
            widthMenu = UIScreen.main.bounds.width * proportionalWidth!
        }
        menuView = LABMenuView(mainColor: barColor,
                               tint: barTintColor,
                               widthMenu: widthMenu,
                               delegate: self)
        
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        self.navigationController!.navigationBar.backgroundColor = barColor
        self.view.backgroundColor = .black
        
        // touch delegate view
        handlerView = UIView(frame: view.frame)
        handlerView.backgroundColor = .black
        handlerView.isHidden = true
        handlerView.alpha = 0
        handlerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LABMenuViewController.outsideMenuClick)))
        self.view.addSubview(handlerView)
        
        self.view.addSubview(menuView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
        super.viewWillAppear(animated)
        
        if barColor == .clear || barColor == .white {
            navigationController!.navigationBar.barStyle = .default
        } else {
            navigationController!.navigationBar.barStyle = .blackTranslucent
        }
        
        navigationController!.view.backgroundColor = barColor
        navigationController!.navigationBar.backgroundColor = barColor
        navigationController!.navigationBar.subviews[0].subviews[0].isHidden = true
        navigationController!.navigationBar.subviews[0].subviews[1].isHidden = true
        
        let statusBarBackground = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: navigationController!.navigationBar.frame.width,
                                                       height: navigationController!.navigationBar.frame.origin.y))
        statusBarBackground.backgroundColor = barColor
        view.addSubview(statusBarBackground)
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
            internalNavigationController.isNavigationBarHidden = true
            
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
        
        self.view.bringSubview(toFront: handlerView)
        self.view.bringSubview(toFront: menuView)
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
    
    @objc func outsideMenuClick() {
        menuView.hide()
    }
    
    func onShow() {
        UIView.animate(withDuration: LABMenuView.LABMenuOptions.animationDuration,
                       animations: {
                        self.onPan(toProgress: 1)
        })
    }
    
    func onHide() {
        UIView.animate(withDuration: LABMenuView.LABMenuOptions.animationDuration,
                       animations: {
                        self.onPan(toProgress: 0)
        })
    }
    
    func onPan(toProgress progress: CGFloat) {
        if progress == 0 {
            menuView.container.alpha = 0
            handlerView.isHidden = true
        } else {
            if menuView.container.alpha == 0  {
                menuView.container.alpha = 1
            }
            if handlerView.isHidden {
                handlerView.isHidden = false
            }
        }
        
        let alpha = LABMenuUtils.getPercentWith(min: 0, max: 2, num: progress)
        let scale = LABMenuUtils.getPercentWith(min: 20, max: 0, num: progress)
        let lastView = internalNavigationController.viewControllers.last!.view!
        handlerView.alpha = alpha
        lastView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        if hideMenuButtonWhenShow {
            let buttonAlpha = LABMenuUtils.getPercentWith(min: 1, max: 0, num: progress)
            navigationItem.leftBarButtonItem?.customView?.alpha = buttonAlpha
        }
    }
}


