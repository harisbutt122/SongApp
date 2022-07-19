//
//  ContentSizedTableView.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 09/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
