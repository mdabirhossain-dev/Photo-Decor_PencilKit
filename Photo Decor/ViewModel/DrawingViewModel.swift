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
    
    // View frame size
    @Published var rect: CGRect = .zero
    
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
        
        // Removing if cancelled
        textBoxes.removeLast()
    }
    
    func saveImage() {
        // Generating image from canvas and textBoxes view...
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        
        // Canvas
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        // Getting image...
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End Render...
        UIGraphicsEndImageContext()
        
        if let image = generatedImage {
            // Saving image...
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("Image succesfully saved...")
        }
    }
}
