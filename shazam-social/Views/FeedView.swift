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
    @ObservedRealmObject var user: User
//    @ObservedResults(User.self) var users
//    @ObservedResults(Post.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var posts
    @Environment(\.presentationMode) var presentationMode
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    @State private var showingShazam = false
    
    @State var posts = [Post]()
    
    func getPosts() {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        print(users.count)
        for user in users {
            print(user.name)
            for post in user.posts {
                posts.append(post)
            }
        }
    }
    
    func playOrStopSong(id: String) {
        switch musicPlayer.playbackState {
        case .playing, .interrupted:
            musicPlayer.pause()
        default:
            musicPlayer.setQueue(with: [id])
            musicPlayer.play()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                SwiftUI.List {
                    ForEach(user.posts) { post in
                        PostCard(post: post)
                        .id(post.id)
                        .contextMenu {
                            Button(action: {
                                playOrStopSong(id: post.songID)
                            }) {
                                Label("Play on Apple Music", systemImage: "music.note")
                            }
                        }
                    }
                    .onDelete(perform: $user.posts.remove)
                }
            }
            .font(.title)
            .padding(.top, 25)
            .navigationTitle("Shazam Social")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    Button(action: {
                        AuthenticationManager.logout()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Logout")
                    }
                    .accentColor(.blue),
                trailing:
                    Button(action: { showingShazam = true }) {
                        Image(systemName: "plus")
                    }
            )
            .navigationDestination(isPresented: $showingShazam) {
                ShazamView(user: user)
            }
            .onAppear {
                getPosts()
            }
        }
    }
}
