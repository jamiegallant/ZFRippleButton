//
//  GTRippleButton.swift
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//
//  Modified and updated by Jamie J Gallant

import UIKit
import QuartzCore

class GTRippleButton: UIButton {
    var ripplePercent: Float = 0.8
    var rippleOverBounds: Bool = false
    
    var rippleColor: UIColor = UIColor(white: 1.0, alpha: 1)
    var rippleBackgroundColor: UIColor = UIColor.clearColor()
    
    var buttonCornerRadius: Float = 0
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    private var cornerRadiusMask: CAShapeLayer {
        get{
            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.blackColor().CGColor
            maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius:CGFloat(buttonCornerRadius)).CGPath
            return maskLayer
        }
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.alpha = 0
        
        rippleOverBounds = false
        
        layer.addSublayer(rippleBackgroundView.layer)
        rippleBackgroundView.layer.addSublayer(rippleView.layer)
    }
    
    private func setupRippleView() {
        var size: CGFloat = CGRectGetWidth(bounds) * CGFloat(ripplePercent)
        var x: CGFloat = (CGRectGetWidth(bounds)/2) - (size/2)
        var y: CGFloat = (CGRectGetHeight(bounds)/2) - (size/2)
        var corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRectMake(x, y, size, size)
        rippleView.layer.cornerRadius = corner
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        UIView.animateWithDuration(0.1, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: nil)
        
        rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
            self.rippleView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        UIView.animateWithDuration(0.1, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: {(success: Bool) -> () in
                UIView.animateWithDuration(0.6 , animations: {
                    self.rippleBackgroundView.alpha = 0
                    }, completion: nil)
        })
        
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut | .BeginFromCurrentState, animations: {
            self.rippleView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rippleBackgroundView.frame = bounds
        layer.mask = cornerRadiusMask
        setupRippleView()
    }
}