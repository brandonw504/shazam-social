//
//  ProfileView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI
import RealmSwift

/**
 Users can see their own Shazamed songs and also log out.
 */
struct ProfileView: View {
    @ObservedRealmObject var user: User
    
    var body: some View {
        VStack {
            if (user.posts.isEmpty) {
                Label("No posts yet!", systemImage: "exclamationmark.triangle.fill").font(.title)
            } else {
                SwiftUI.List {
                    ForEach(user.posts.reversed()) { post in
                        NavigationLink(destination: ProfilePostView(post: post)) {
                            Card(post: post)
                        }
                    }
                    .onDelete(perform: $user.posts.remove)
                }
            }
        }
        .navigationTitle(user.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    AuthenticationManager.logout()
                }
            }
        }
    }
}

struct Card: View {
    var post: Post
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: post.albumArtURL).frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(post.title).font(.headline)
                Text(post.artist).font(.caption).foregroundColor(.gray)
            }
        }
    }
}
