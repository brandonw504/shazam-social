//
//  NewPostView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct NewPostView: View {
    @Binding var name: String
    var title: String?
    var artist: String?
    var albumArtURL: URL?
    
    @State private var caption = ""
    @State private var showingAlert = false
    @State private var showingHome = false
    
    @ObservedResults(Post.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var posts
        
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
        
        let post = Post(name: self.name, title: songTitle, artist: songArtist, albumArtURL: albumArtURL.absoluteString, caption: self.caption)
        $posts.append(post)

//        let realm = try! Realm()
//        do {
//            try realm.write {
//                realm.add(post)
//            }
//        } catch let error {
//            print("Failed to add post: \(error.localizedDescription)")
//        }
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
            Button(action: {
                if (caption == "") {
                    showingAlert = true
                } else {
                    DispatchQueue.main.async {
                        addPost()
                    }
                    showingHome = true
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
        .navigationDestination(isPresented: $showingHome) {
            ContentView(name: $name)
        }
    }
}
