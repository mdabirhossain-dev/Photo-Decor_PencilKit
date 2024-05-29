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
                
                // TextField
                TextField("Add text..", text: $drawingVM.textBoxes[drawingVM.currentIndex].text)
                    .font(.system(size: 28))
                    .preferredColorScheme(.dark)
                
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
                        
                    } label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
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
