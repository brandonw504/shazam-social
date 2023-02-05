//
//  NewPostView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct NewPostView: View {
    @ObservedRealmObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationManager = LocationManager()
    @StateObject var localSearchViewData = LocalSearchViewData()
    
    @Binding var popView: Bool
    
    var title: String?
    var artist: String?
    var albumArtURL: URL?
    var songID: String?
    
    @State private var caption = ""
    @State private var location = ""
    @State private var showingAlert = false
    @State private var showingLocationPicker = false
        
    func addPost() -> Void {
        guard let songTitle = self.title else {
            return
        }
        guard let songArtist = self.artist else {
            return
        }
        guard let albumArtURL = self.albumArtURL else {
            return
        }
        
        let post = Post(name: user.name, title: songTitle, artist: songArtist, albumArtURL: albumArtURL.absoluteString, songID: songID ?? "", caption: self.caption, createdAt: Date(), location: location, latitude: locationManager.location?.latitude, longitude: locationManager.location?.longitude)
        $user.posts.append(post)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            AsyncImage(url: albumArtURL) { image in
                image
                    .resizable()
                    .frame(width: 300, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } placeholder: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.purple.opacity(0.5))
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .redacted(reason: .privacy)
            }
            VStack(alignment: .center) {
                Text(title ?? "Title")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text(artist ?? "Artist Name")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }.padding()
            
            TextField("Caption", text: $caption)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Text(location).foregroundColor(.gray)
                Spacer()
                Button(action: {
                    showingLocationPicker = true
                    locationManager.requestLocation()
                }) {
                    HStack {
                        Text("Locate me")
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding()
            
            Button(action: {
                if (caption == "") {
                    showingAlert = true
                } else {
                    DispatchQueue.main.async {
                        addPost()
                    }
                    popView = true
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Share Post")
            }
            .buttonStyle(.borderedProminent)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Caption cannot be empty"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .navigationDestination(isPresented: $showingLocationPicker) {
            LocationView(location: $location)
        }
    }
}
