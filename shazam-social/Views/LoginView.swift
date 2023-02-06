//
//  LoginView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authManager = AuthenticationManager()
    @State var error: Error?
    
    @State private var name = ""
    @State private var showingSignUp = false
    @State private var isLoggingIn = false
    @State private var showingAlert = false
    @State private var scale = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if isLoggingIn {
                    ProgressView()
                }
                
                if let error = error {
                    Text("Error: \(error.localizedDescription)")
                }
                
                Group {
                    AsyncImage(url: URL(string: "https://assets.stickpng.com/images/580b57fcd9996e24bc43c538.png")) { image in
                        image
                            .resizable()
                            .padding()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale ? 0.95 : 1.05)
                            .task {
                                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                    scale.toggle()
                                }
                            }
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text("Shazam Social").font(.largeTitle)
                }
                
                Group {
                    TextField("Email", text: $authManager.email)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Password", text: $authManager.password)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                
                if authManager.isLoading {
                    ProgressView()
                }
                
                if let error = authManager.errorMessage {
                    Text(error)
                        .foregroundColor(.pink)
                }
                
                Group {
                    Button("Log In") {
                        isLoggingIn = true
                        authManager.login()
                        isLoggingIn = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!authManager.authIsEnabled)
                    
                    Button("Don't have an account? Sign up!") {
                        showingSignUp = true
                    }
                    .disabled(authManager.isLoading)
                }
            }
            .navigationDestination(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
