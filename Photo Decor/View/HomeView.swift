//
//  HomeView.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @StateObject var drawingVM = DrawingViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if let _ = UIImage(data: drawingVM.imageData) {
                        DrawingView()
                            .environmentObject(drawingVM)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    if let _ = UIImage(data: drawingVM.imageData) {
                                        HStack {
                                            Button("Cancel") {
                                                drawingVM.cancelPhotoEditing()
                                            }
                                            .buttonBorderShape(.capsule)
                                            .buttonStyle(.bordered)
                                            
                                            Button("+") {
                                                drawingVM.showPicker.toggle()
                                            }
                                            .buttonBorderShape(.capsule)
                                            .buttonStyle(.borderedProminent)
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        
                        Spacer()
                    } else {
                        Button("+") {
                            drawingVM.showPicker.toggle()
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .navigationTitle("Photo Decor")
            }
            
            if drawingVM.addNewBox {
                
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    HStack {
                        // TextField
                        TextField("Add text..", text: $drawingVM.textBoxes[drawingVM.currentIndex].text)
                            .font(.system(size: 28))
                            .foregroundColor(drawingVM.textBoxes[drawingVM.currentIndex].textColor)
                            .preferredColorScheme(.dark)
                        
                        Button {
                            drawingVM.textBoxes[drawingVM.currentIndex].isBold.toggle()
                        } label: {
                            Text(drawingVM.textBoxes[drawingVM.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(drawingVM.textBoxes[drawingVM.currentIndex].isBold ? .none : .bold)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Add and cancel button
                    HStack {
                        Button {
                            drawingVM.cancelTextView()
                        } label: {
                            Text("Cancel")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Button {
                            // Closing the view
                            drawingVM.toolPicker.setVisible(true, forFirstResponder: drawingVM.canvas)
                            drawingVM.canvas.becomeFirstResponder()
                            
                            withAnimation {
                                drawingVM.addNewBox = false
                            }
                        } label: {
                            Text("Add")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .overlay(
                        ColorPicker("", selection: $drawingVM.textBoxes[drawingVM.currentIndex].textColor)
                            .labelsHidden()
                        , alignment: .center
                    )
                }
                .padding(20)
                .frame(height: 150, alignment: .top)
                .background(Color.gray)
                .cornerRadius(15)
                .padding()
                
            }
        }
        // Showing ImagePicker in a sheet
        .sheet(isPresented: $drawingVM.showPicker) {
            ImagePicker(showPicker: $drawingVM.showPicker, imageData: $drawingVM.imageData)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
