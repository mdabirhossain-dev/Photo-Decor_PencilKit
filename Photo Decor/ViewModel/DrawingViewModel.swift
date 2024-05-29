//
//  DrawingViewModel.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showPicker = false
    @Published var imageData = Data(count: 0)
    
    // Drawing canvas...
    @Published var canvas = PKCanvasView()
    
    // Tool picker
    @Published var toolPicker = PKToolPicker()
    
    // TextBox list
    @Published var textBoxes: [TextBox] = []
    @Published var addNewBox: Bool = false
    
    // Current index
    @Published var currentIndex: Int = 0
    
    // Cancel image editing...
    func cancelPhotoEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
    }
    
    // Cancel AddTextView {
    func cancelTextView() {
        // Showing toolBar again...
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            addNewBox = false
        }
    }
}
