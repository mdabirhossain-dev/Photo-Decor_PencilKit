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
        NavigationView {
            VStack {
                if let image = UIImage(data: drawingVM.imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let image = UIImage(data: drawingVM.imageData) {
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
