//
//  ContentView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    @State private var loggingOut = false
    
    func logOut() {
        if let app = app {
            if let user = app.currentUser {
                user.logOut(completion: { _ in
                    DispatchQueue.main.async {
                        self.name = ""
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        loggingOut = true
    }

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house").font(.system(size: 25))
                }
            
            ShazamView(name: $name)
                .tabItem {
                    Image(systemName: "shazam.logo").font(.system(size: 25))
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: { logOut() }) {
                Text("Logout")
            }
            .accentColor(.blue)
        )
    }
}
