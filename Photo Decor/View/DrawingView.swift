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
    @State private var menuPosition: CGSize = .zero
    @State private var menuPopUp = false
    @State private var selectedIndex: Int? = 0
    
    var body: some View {
        ZStack {
            GeometryReader { geo -> AnyView in
                let size = geo.frame(in: .global)
                
                DispatchQueue.main.async {
                    if drawingVM.rect == .zero {
                        drawingVM.rect = size
                    }
                }
                
                return AnyView(
                    ZStack {
                        // PencilKit drawing (UIKit)
                        CanvasView(canvas: $drawingVM.canvas, imageData: $drawingVM.imageData, toolPicker: $drawingVM.toolPicker, rect: size.size)
                        
                        // Custom texts...
                        // Displaying added text's...
                        ForEach(drawingVM.textBoxes) { box in
                            Text(drawingVM.textBoxes[drawingVM.currentIndex].id == box.id && drawingVM.addNewBox ? "" : box.text)
                                .font(.system(size: 28))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .padding(3)
                                .cornerRadius(15)
                                .border(selectedIndex == getIndex(textBox: box) ? .white : .clear, width: selectedIndex == getIndex(textBox: box) ? 2 : 0)
                                .offset(box.offset)
                            // Drag gesture
                                .gesture(
                                    DragGesture()
                                        .onChanged({ (value) in
                                            let current = value.translation
                                            
                                            // Adding with last offset
                                            let lastOffset = box.lastOffset
                                            let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                            
                                            drawingVM.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                        })
                                        .onEnded({ (value) in
                                            // Saving last value for exac position...
                                            drawingVM.textBoxes[getIndex(textBox: box)].lastOffset = value.translation
                                        }))
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded({ _ in
                                            print("Tapping...")
                                            withAnimation {
                                                selectedIndex = getIndex(textBox: box)
                                                
                                                menuPosition = size.size
                                                menuPopUp = true
                                            }
                                        })
//                                    LongPressGesture(minimumDuration: 1.3)
//                                        .onEnded({ _ in
//                                            menuPosition = size.size
//                                            menuPopUp = true
//                                        })
                                    
//                                    onLongPressGesture(minimumDuration: 1.3, perform: {
//                                        menuPosition = size.size
//                                        menuPopUp = true
//                                    })
                                )
                            
                            
                            // Editing added texts on long press...
//                                .onLongPressGesture(minimumDuration: 1.5) {
//                                    menuPosition = size.size
//                                    menuPopUp = true
//                                }
                                .overlay (
                                    HStack(spacing: 1) {
                                        if menuPopUp && selectedIndex == getIndex(textBox: box) {
                                            Button {
                                                // Closing the PopUp
                                                drawingVM.currentIndex = getIndex(textBox: box)
                                                drawingVM.textBoxes.remove(at: drawingVM.currentIndex)
                                                
                                                withAnimation {
                                                    menuPopUp = false
                                                    selectedIndex = nil
                                                }
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .padding(5)
                                                    .foregroundColor(.white)
                                                    .background(Color(uiColor: .systemGray6))
                                                    .cornerRadius(geo.size.height / 2)
                                            }
                                            
//                                            Button("Edit") {
//                                                // Closing the toolBar...
//                                                drawingVM.toolPicker.setVisible(false, forFirstResponder: drawingVM.canvas)
//                                                drawingVM.canvas.resignFirstResponder()
//
//                                                drawingVM.currentIndex = getIndex(textBox: box)
//                                                withAnimation {
//                                                    drawingVM.addNewBox = true
//                                                }
//
//                                                menuPopUp = false
//                                            }
//                                            .buttonStyle(.borderedProminent)
//
//                                            Button("Delete") {
//                                                drawingVM.currentIndex = getIndex(textBox: box)
//                                                drawingVM.textBoxes.remove(at: drawingVM.currentIndex)
//
//                                                menuPopUp = false
//                                            }
//                                            .buttonStyle(.borderedProminent)
                                        } else {
                                            EmptyView()
                                        }
                                    }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .offset(box.offset)
                                        .padding([.bottom, .leading], 80)
                                    , alignment: .center
                                )
                        }
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    drawingVM.saveImage()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Aa") {
                    // Creating one new box...
                    drawingVM.textBoxes.append(TextBox())
                    
                    // Updating index...
                    drawingVM.currentIndex = drawingVM.textBoxes.count - 1
                    
                    withAnimation {
                        drawingVM.addNewBox.toggle()
                    }
                    
                    drawingVM.toolPicker.setVisible(false, forFirstResponder: drawingVM.canvas)
                    drawingVM.canvas.resignFirstResponder()
                }
            }
        }
    }
    
    func getIndex(textBox: TextBox) -> Int {
        let index = drawingVM.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
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
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
            
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
