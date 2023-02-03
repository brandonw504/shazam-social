//
//  NewPostView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct NewPostView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Binding var name: String
    
    @State private var songTitle = ""
    @State private var songArtist = ""
    @State private var albumArtURL = ""
    
    @ObservedResults(Post.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var posts
        
    func addPost() -> Void {
        let post = Post(name: self.name, songTitle: self.songTitle, songArtist: self.songArtist, albumArtURL: self.albumArtURL)
        $posts.append(post)
        self.songTitle = ""
        self.songArtist = ""
        self.albumArtURL = ""
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: viewModel.shazamMedia.albumArtURL) { image in
                    image
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10, opaque: true)
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            } placeholder: {
                EmptyView()
            }
            VStack(alignment: .center) {
                Spacer()
                AsyncImage(url: viewModel.shazamMedia.albumArtURL) { image in
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
                    Text(viewModel.shazamMedia.title ?? "Title")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Text(viewModel.shazamMedia.artistName ?? "Artist Name")
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }.padding()
                Spacer()
                Button(action: {viewModel.startOrEndListening()}) {
                    Text(viewModel.isRecording ? "Listening..." : "Start Shazaming")
                        .frame(width: 300)
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .shadow(radius: 4)
            }
        }
    }
}
