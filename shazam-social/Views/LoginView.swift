//
//  LoginView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI

struct LoginView: View {
    @State private var name = ""
    @State private var showingHome = false
    @State private var isLoggingIn = false
    @State private var showingAlert = false
    
    func logIn() {
        isLoggingIn = true
        if let app = app {
            app.login(credentials: .anonymous) { result in
                isLoggingIn = false
                showingHome = true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Shazam Social").font(.largeTitle)
                TextField("Name", text: $name)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
                
                if isLoggingIn {
                    ProgressView()
                }
                
                Button(action: { name == "" ? showingAlert = true : logIn() }) {
                    Text("Login").padding(.horizontal)
                    Image(systemName: "arrow.right.square")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text("Name cannot be empty"), dismissButton: .default(Text("OK")))
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .cornerRadius(8)
            }
            .navigationDestination(isPresented: $showingHome) {
                FeedView(name: $name)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
