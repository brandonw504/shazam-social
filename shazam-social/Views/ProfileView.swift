//
//  ProfileView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI
import RealmSwift

/**
 `Users can see their own Shazamed songs and log out.`
 */
struct ProfileView: View {
    @ObservedRealmObject var user: User
    
    var body: some View {
        VStack {
            SwiftUI.List {
                ForEach(user.posts) { post in
                    NavigationLink(destination: ProfilePostView(post: post)) {
                        Card(post: post)
                    }
                }
                .onDelete(perform: $user.posts.remove)
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
