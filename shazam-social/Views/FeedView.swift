//
//  FeedView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift
import MediaPlayer
import CoreLocation

struct FeedView: View {
    @ObservedRealmObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var showingShazam = false
    @State var posts = [Post]()
    
    func getPosts() {
        let client = app!.currentUser?.mongoClient("mongodb-atlas")
        let database = client?.database(named: "shazam-social-db")
        let collection = database!.collection(withName: "User")
        
        let pipeline: [Document] = [["$unwind": ["path": "$posts"]], ["$project": ["posts": 1]]]
        collection.aggregate(pipeline: pipeline) { result in
            switch result {
            case .failure(let error):
                print("Call to MongoDB failed: \(error.localizedDescription)")
                return
            case .success(let results):
                for result in results {
                    let res = result["posts"]!!.documentValue!
                    let post = Post(name: res["name"]!!.stringValue!, title: res["title"]!!.stringValue!, artist: res["artist"]!!.stringValue!, albumArtURL: res["albumArtURL"]!!.stringValue!, songID: res["songID"]!!.stringValue!, caption: res["caption"]!!.stringValue!, createdAt: res["createdAt"]!!.dateValue!, location: res["location"]!!.stringValue, latitude: res["latitude"]!!.doubleValue, longitude: res["longitude"]!!.doubleValue)
                    posts.append(post)
                }
            }
        }
    }
    
    func playOrStopSong(id: String) {
        switch musicPlayer.playbackState {
        case .playing, .interrupted:
            musicPlayer.pause()
        default:
            musicPlayer.setQueue(with: [id])
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                SwiftUI.List {
                    ForEach(posts.reversed()) { post in
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
                    Button(action: {
                        showingShazam = true
                        posts.removeAll()
                    }) {
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
