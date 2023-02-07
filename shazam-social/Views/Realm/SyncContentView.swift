//
//  SyncContentView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/4/23.
//

import SwiftUI
import RealmSwift

/**
 Directs the user to the login page or opens a realm with a logged in user.
 */
struct SyncContentView: View {
    // React to login state changes in the Realm app object.
    @ObservedObject var app: RealmSwift.App

    var body: some View {
        if let user = app.currentUser {
            // If there is a logged in user, pass the user ID as the partitionValue to the view that opens a realm.
            OpenSyncedRealmView().environment(\.partitionValue, user.id)
        } else {
            LoginView()
        }
    }
}
