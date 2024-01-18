//
//  ContentView.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 15/01/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logstatus: Bool = false
    var body: some View {
      
        if logstatus {
            MainView()
        } else {
            LoginView()
        }
       
    }
}

#Preview {
    ContentView()
}
