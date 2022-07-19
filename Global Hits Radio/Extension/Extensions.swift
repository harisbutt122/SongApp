//
//  Extensions.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 07/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import UIKit

extension UIImageView {
    
//    @objc override func applyCircleShadow(shadowOpacity: Float = 0.3,
//                                    shadowColor: CGColor = UIColor.black.cgColor,
//                                    shadowOffset: CGSize = CGSize.zero) {
//
//        // Use UIImageView.hashvalue as background view tag (should be unique)
//        let background: UIView = superview?.viewWithTag(hashValue) ?? UIView()
//        background.frame = frame
//        background.backgroundColor = backgroundColor
//        background.tag = hashValue
//        background.applyCircleShadow(shadowRadius: 2.0, shadowOpacity: shadowOpacity, shadowColor: shadowColor, shadowOffset: shadowOffset)
//        layer.cornerRadius = background.layer.cornerRadius
//        layer.masksToBounds = true
//        superview?.insertSubview(background, belowSubview: self)
//    }
    
    func setRounded() {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
//      layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 25

//      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//      layer.shouldRasterize = true
//      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}

import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
