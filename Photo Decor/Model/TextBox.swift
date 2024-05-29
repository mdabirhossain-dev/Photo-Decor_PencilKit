//
//  TextBox.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import Foundation
import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    
    // For dragging view over the screen...
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    
    // Any property can be added........
}
