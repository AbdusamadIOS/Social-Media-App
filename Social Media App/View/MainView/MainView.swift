//
//  MainView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 16/01/24.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        // MARK: TabView With Recent Post's And Profile Tabs
        TabView {
            PostView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
            }
        }
        // Changing Tab Lable Tint to Black
            .tint(.black)
    }
}

#Preview {
    ContentView()
}
