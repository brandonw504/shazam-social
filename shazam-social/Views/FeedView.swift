//
//  FeedView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct FeedView: View {
    @ObservedResults(Post.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var posts
    
    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(alignment: .leading, spacing: 5) {
                            ForEach(posts) { post in
                                VStack(alignment: .leading) {
                                    Text(post.name)
                                    Text(post.songTitle)
                                    Text(post.songArtist)
                                }
                                .id(post._id)
                                .padding()
                            }

                        }
                    }
                }
            }
            .font(.title)
            .padding(.top, 25)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
