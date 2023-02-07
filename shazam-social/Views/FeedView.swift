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

/**
 The homepage, where users can see each others' posts and play the songs.
 */
struct FeedView: View {
    @ObservedRealmObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var showingProfile = false
    @State private var showingShazam = false
    @State private var showingMap = false
    @State private var showingAlert = false
    @State var posts = [Post]()
    
    // MARK: - Database
    // In the future, I will switch to using protocols in a database manager.
    func getPosts() {
        guard let client = app?.currentUser?.mongoClient("mongodb-atlas") else {
            print("Error: Could not connect to database.")
            return
        }
        let database = client.database(named: "shazam-social-db")
        let collection = database.collection(withName: "User")
        
        // The pipeline gets the embedded Post objects and filters down to get only the posts (since unwind just makes the posts a property of the user).
        let pipeline: [Document] = [["$unwind": ["path": "$posts"]], ["$project": ["posts": 1]]]
        collection.aggregate(pipeline: pipeline) { result in
            switch result {
            case .failure(let error):
                print("Call to MongoDB failed: \(error.localizedDescription)")
                return
            case .success(let results):
                for result in results {
                    // MongoDB gives back a document that's wrapped in multiple optionals, so it looks very messy.
                    if let res = result["posts"]??.documentValue {
                        // I force unwrap the post properties because I know when I set them in NewPostView they're guaranteed.
                        let post = Post(name: res["name"]!!.stringValue!,
                                        userID: res["userID"]!!.objectIdValue!,
                                        title: res["title"]!!.stringValue!,
                                        artist: res["artist"]!!.stringValue!,
                                        albumArtURL: res["albumArtURL"]!!.stringValue!,
                                        songID: res["songID"]!!.stringValue!,
                                        caption: res["caption"]!!.stringValue!,
                                        createdAt: res["createdAt"]!!.dateValue!,
                                        location: res["location"]!!.stringValue,
                                        latitude: res["latitude"]!!.doubleValue,
                                        longitude: res["longitude"]!!.doubleValue)
                        posts.append(post)
                    } else {
                        print("Result from database was nil, no posts found.")
                    }
                }
            }
        }
    }
    
    // MARK: - Music Player
    func playSong(id: String) {
        musicPlayer.setQueue(with: [id])
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    func stopSong() {
        switch musicPlayer.playbackState {
        case .playing:
            musicPlayer.stop()
        default:
            return
        }
    }
    
    // Play the tapped song. If it's already playing, pause it.
    // If it's a different song, stop the current one and play the new one.
    func handleSong(id: String) {
        switch musicPlayer.playbackState {
        case .playing:
            if (musicPlayer.nowPlayingItem?.playbackStoreID == id) {
                musicPlayer.pause()
            } else {
                musicPlayer.stop()
                playSong(id: id)
            }
        default:
            if (musicPlayer.nowPlayingItem?.playbackStoreID == id) {
                musicPlayer.play()
            } else {
                playSong(id: id)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                SwiftUI.List {
                    ForEach(posts.reversed()) { post in
                        PostCard(post: post)
                        .id(post.id)
                        .onTapGesture {
                            handleSong(id: post.songID)
                        }
                    }
                }
                .refreshable {
                    posts.removeAll()
                    getPosts()
                }
            }
            .font(.title)
            .padding(.top, 25)
            .navigationTitle("Shazam Social")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        stopSong()
                        showingProfile = true
                    }) {
                        Image(systemName: "person.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        stopSong()
                        showingShazam = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        stopSong()
                        showingMap = true
                    }) {
                        HStack {
                            Text("View Map")
                            Image(systemName: "mappin.and.ellipse")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showingProfile) { ProfileView(user: user) }
            .navigationDestination(isPresented: $showingShazam) { ShazamView(user: user) }
            .navigationDestination(isPresented: $showingMap) { MapView(posts: $posts) }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("You can't delete someone else's post."), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // If we revisit the feed, reload it to fetch any new posts.
                posts.removeAll()
                getPosts()
            }
        }
    }
}
