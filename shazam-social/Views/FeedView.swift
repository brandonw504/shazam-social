//
//  FeedView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift
import MediaPlayer

struct FeedView: View {
    @ObservedResults(Post.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var posts
    @Environment(\.presentationMode) var presentationMode
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    @Binding var name: String
    @State private var loggingOut = false
    @State private var showingShazam = false
    
    func playOrStopSong(id: String) {
        switch musicPlayer.playbackState {
        case .playing:
            musicPlayer.pause()
        case .paused:
            musicPlayer.setQueue(with: [id])
            musicPlayer.play()
        case .stopped:
            musicPlayer.setQueue(with: [id])
            musicPlayer.play()
        case .interrupted:
            musicPlayer.pause()
        default:
            musicPlayer.setQueue(with: [id])
            musicPlayer.play()
        }
    }
    
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
        VStack(spacing: 25) {
            SwiftUI.List {
                ForEach(posts) { post in
                    PostCard(post: post)
                    .id(post._id)
                    .onTapGesture {
                        playOrStopSong(id: post.songID)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            $posts.remove(post)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .font(.title)
        .padding(.top, 25)
        .navigationTitle("Shazam Social")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: { logOut() }) {
                    Text("Logout")
                }
                .accentColor(.blue),
            trailing:
                Button(action: { showingShazam = true }) {
                    Image(systemName: "plus")
                }
        )
        .navigationDestination(isPresented: $showingShazam) {
            ShazamView(name: $name)
        }
    }
}
