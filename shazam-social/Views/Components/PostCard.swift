//
//  PostCard.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI

struct PostCard: View {
    var post: Post
    
    var body: some View {
        Section {
            ZStack {
                VStack {
                    HStack {
                        Text(post.title).font(.title).padding(3)
                        Divider()
                        Text(post.artist).font(.headline).padding(3).foregroundColor(.gray)
                        Spacer()
                    }
                    
                    AsyncImage(url: URL(string: post.albumArtURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    HStack {
                        Text(post.name).font(.headline).padding(3)
                        Spacer()
                    }
                    
                    HStack {
                        Text(post.caption).font(.caption).padding(3)
                        Spacer()
                    }
                    
                    Divider()
                }
            }
        }
    }
}
