//
//  ContentView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    @State private var loggingOut = false

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house").font(.system(size: 25))
                }
            
            NewPostView(name: $name)
                .tabItem {
                    Image(systemName: "shazam.logo").font(.system(size: 25))
                }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
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
            }) {
                Text("Logout")
            }
            .accentColor(.blue)
        )
    }
}