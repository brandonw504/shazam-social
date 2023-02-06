//
//  OpenSyncedRealmView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/4/23.
//

import SwiftUI
import RealmSwift

/**
 `Opens a synced realm and creates a user if needed.`
 */
struct OpenSyncedRealmView: View {
    // Try to open a realm, if there's no connection then use a previously opened realm.
    @AutoOpen(appId: realmKey, partitionValue: "", timeout: 4000) var realmOpen
    
    var body: some View {
        switch realmOpen {
        case .connecting:
            ProgressView()
        case .waitingForUser:
            ProgressView("Waiting for user to log in...")
        case .open(let realm):
            FeedView(user: {
                // If there's no user in the realm, make a new user and pass it into the feed.
                if (realm.objects(User.self).count == 0) {
                    do {
                        try realm.write {
                            realm.add(User(name: AuthenticationManager.name))
                        }
                    } catch let error {
                        print("Failed to create user: \(error.localizedDescription)")
                    }
                }
                return realm.objects(User.self).first ?? User()
            }())
        case .progress(let progress):
            ProgressView(progress)
        case .error(let error):
            ErrorView(error: error)
        }
    }
}

struct ErrorView: View {
    var error: Error
        
    var body: some View {
        VStack {
            Text("Error opening the realm: \(error.localizedDescription)")
        }
    }
}
