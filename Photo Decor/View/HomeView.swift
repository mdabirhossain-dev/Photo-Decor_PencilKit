//
//  HomeView.swift
//  Photo Decor
//
//  Created by Md Abir Hossain on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Photo Picker")
                .navigationTitle("Photo Decor")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
