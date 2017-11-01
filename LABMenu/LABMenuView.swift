//
//  MenuView.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

open class LABMenuView: UIView {
    
    public struct LABMenuOptions {
        public static var width: CGFloat = UIScreen.main.bounds.width * 0.8
        public static var animationDuration: TimeInterval = 0.4
    }
    
    private let minOrigin: CGFloat = -LABMenuOptions.width + 10
    private let maxOrigin: CGFloat = 0.0
    
    open var isShowing: Bool = false
    open var mainColor: UIColor!
    open var tint: UIColor!
    
    // private var panGesture: UIPanGestureRecognizer!
    
    private struct LeftPanState {
        static var frameAtStartOfPan: CGRect = CGRect.zero
        static var startPointOfPan: CGPoint = CGPoint.zero
        static var lastState : UIGestureRecognizerState = .ended
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var container: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(mainColor: UIColor, tint: UIColor) {
        self.mainColor = mainColor
        self.tint = tint
        
        super.init(frame: CGRect(x: minOrigin,
                                 y: 0,
                                 width: LABMenuOptions.width,
                                 height: UIScreen.main.bounds.height))
        
        Bundle(for: LABMenuView.self).loadNibNamed("LABMenuView",
                                                owner: self,
                                                options: nil)
        
        self.view!.frame = CGRect(origin: CGPoint.zero,
                                  size: frame.size)
        
        self.addSubview(self.view!)
    }
    
    public func setContentView(contentView: LABMenuContainer) {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(LABMenuView.onPan(_:)))
        
        contentView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        contentView.frame = self.container.frame
        self.container.addSubview(contentView)
    }
    
    public func show() {
        UIView.animate(withDuration: LABMenuOptions.animationDuration,
                       animations: {
                        self.frame.origin.x = 0
        }, completion: {_ in
            self.isShowing = true
        })
    }
    
    public func hide() {
        UIView.animate(withDuration: LABMenuOptions.animationDuration,
                       animations: {
                        self.frame.origin.x = self.minOrigin
        }, completion: {_ in
            self.isShowing = false
        })
    }
    
    @objc private func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if LeftPanState.lastState != .ended &&
                LeftPanState.lastState != .cancelled &&
                LeftPanState.lastState != .failed
            {
                return
            }
            
            LeftPanState.frameAtStartOfPan = self.frame
            LeftPanState.startPointOfPan = sender.location(in: self)
            
        case .changed:
            if LeftPanState.lastState != .began &&
                LeftPanState.lastState != .changed
            {
                return
            }
            
            let translation: CGPoint = sender.translation(in: sender.view!)
            self.frame = applyTopTransition(translation, toFrame: LeftPanState.frameAtStartOfPan)
        case .ended, .cancelled:
            if LeftPanState.lastState != .changed {
                return
            }
            
            let velocity:CGPoint = sender.velocity(in: sender.view)
            
            if velocity.x > 0 {
                show()
            } else {
                hide()
            }
        case .failed, .possible:
            break
        }
        
        LeftPanState.lastState = sender.state
    }
    
    private func applyTopTransition(_ translation: CGPoint, toFrame:CGRect) -> CGRect {
        
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        var newFrame: CGRect = toFrame
        
        if newOrigin < minOrigin {
            newOrigin = minOrigin
        } else if newOrigin > maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }
}
