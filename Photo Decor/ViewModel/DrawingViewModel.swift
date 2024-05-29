//
//  DrawingViewModel.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import Foundation

class DrawingViewModel: ObservableObject {
    @Published var showPicker = false
    @Published var imageData = Data(count: 0)
    
    // Cancel image editing...
    func cancelPhotoEditing() {
        imageData = Data(count: 0)
    }
}
