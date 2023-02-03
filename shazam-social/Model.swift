//
//  Model.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import Foundation
import RealmSwift

final class Post: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var songTitle: String
    @Persisted var songArtist: String
    @Persisted var albumArtURL: String
    @Persisted var createdAt: Date?
    
    convenience init(name: String, songTitle: String, songArtist: String, albumArtURL: String) {
        self.init()
        self.name = name
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.albumArtURL = albumArtURL
        self.createdAt = Date()
    }
}
