//
//  DrawingView.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    // MARK: - Properties
    @EnvironmentObject var drawingVM: DrawingViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geo -> AnyView in
                let size = geo.frame(in: .global).size
                
                return AnyView(
                    ZStack {
                        // PencilKit drawing (UIKit)
                        CanvasView(canvas: $drawingVM.canvas, imageData: $drawingVM.imageData, toolPicker: $drawingVM.toolPicker, rect: size)
                        
                        // Custom texts...
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Aa") {
                    // Creating one new box...
                    drawingVM.textBoxes.append(TextBox())
                    
                    withAnimation {
                        drawingVM.addNewBox.toggle()
                    }
                    
                    drawingVM.toolPicker.setVisible(false, forFirstResponder: drawingVM.canvas)
                    drawingVM.canvas.resignFirstResponder()
                }
            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: - Drawing canvas
struct CanvasView: UIViewRepresentable {
    // For drawing view
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    
    // View size
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        // Appending image in canvas subview...
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            // Sending image back side
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            // Showing tool picke...
            // Setting first responder and making visible...
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            
        }
        
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // For each action UI will update...
    }
}
