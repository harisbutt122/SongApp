//
//  RoundShadowView.swift
//  Global Hits Radio
//
//  Created by Macbook Pro  on 07/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.

//

import UIKit

class RoundShadowView: UIView {
    
    let containerView = UIView()
    var cornerRadius: CGFloat = 6.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    override func layoutSubviews() {
        layoutView()
    }
    
    func layoutView() {
        
        cornerRadius = self.frame.height / 2
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8.0)
        
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 6.0
        
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
