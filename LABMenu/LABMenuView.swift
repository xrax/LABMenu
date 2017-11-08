//
//  MenuView.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/1/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

import UIKit

protocol LABMenuViewDelegate {
    func onPan(toProgress progress: CGFloat)
    func onShow()
    func onHide()
}

open class LABMenuView: UIView {
    
    public struct LABMenuOptions {
        public static var width: CGFloat = UIScreen.main.bounds.width * 0.8
        public static var animationDuration: TimeInterval = 0.3
    }
    
    private let minOrigin: CGFloat = -LABMenuOptions.width + 10
    private let maxOrigin: CGFloat = 0.0
    private var delegate: LABMenuViewDelegate!
    
    open var isShowing: Bool = false
    open var mainColor: UIColor!
    open var tint: UIColor!
    
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
    
    init(mainColor: UIColor, tint: UIColor, delegate: LABMenuViewDelegate) {
        self.mainColor = mainColor
        self.tint = tint
        self.delegate = delegate
        
        super.init(frame: CGRect(x: minOrigin,
                                 y: 0,
                                 width: LABMenuOptions.width,
                                 height: UIScreen.main.bounds.height))
        
        Bundle(for: LABMenuView.self).loadNibNamed("LABMenuView",
                                                   owner: self,
                                                   options: nil)
        
        self.view!.frame = CGRect(origin: CGPoint.zero,
                                  size: self.frame.size)
        self.alpha = 0
        self.addSubview(self.view!)
    }
    
    public func setContentView(contentView: LABMenuContainer) {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(LABMenuView.onPan(_:)))
        
        contentView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        self.container.addSubview(contentView)
    }
    
    public func show() {
        container.alpha = 1
        UIView.animate(withDuration: LABMenuOptions.animationDuration,
                       animations: {
                        self.delegate.onShow()
                        self.frame.origin.x = 0
        }, completion: {_ in
            self.isShowing = true
        })
    }
    
    public func hide() {
        UIView.animate(withDuration: LABMenuOptions.animationDuration,
                       animations: {
                        self.delegate.onHide()
                        self.frame.origin.x = self.minOrigin
        }, completion: {_ in
            self.isShowing = false
            self.container.alpha = 0
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
            delegate.onPan(toProgress: LABMenuUtils.getPercentWith(min: minOrigin,
                                                                   max: maxOrigin,
                                                                   num: frame.origin.x))
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

