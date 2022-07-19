//
//  ImageContentView.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 06/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import Foundation
import UIKit
import SwiftUI

struct ImageContentView: View {
    var body: some View {
        Image("message_icon")
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.white, lineWidth: 6))
    }
}
