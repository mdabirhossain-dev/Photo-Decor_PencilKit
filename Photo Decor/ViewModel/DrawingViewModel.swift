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
    
    // Alert
    @Published var showAlert = false
    @Published var alertMsg = ""
    
    // Cancel image editing...
    func cancelPhotoEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
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
        // Avoiding already added texts removal...
//        if !textBoxes[currentIndex].isAdded {
//            textBoxes.removeLast()
//        }
    }
    
    func saveImage() {
        // Generating image from canvas and textBoxes view...
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        // Canvas
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        // Drawing Textboxes...
        let SwiftUIView = ZStack {
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: 28))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
            }
        }
        
        let controller = UIHostingController(rootView: SwiftUIView).view
        controller?.frame = rect
        // Clearing background...
        controller?.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller?.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        // Getting image...
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End Render...
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData() {
            // Saving image...
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("Image succesfully saved...")
            
            // Triggering alert...
            alertMsg = "Image successfully saved.."
            showAlert.toggle()
        }
    }
}
