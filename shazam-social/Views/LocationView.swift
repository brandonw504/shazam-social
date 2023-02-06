//
//  LocationView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI

/**
 `Users can search for a location.`
 */
struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationManager = LocationManager()
    @StateObject var localSearchViewData = LocalSearchViewData()
    
    @Binding var location: String
    
    @State private var showingSearchResults = false
    @FocusState private var locationIsFocused: Bool
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                /*
                 I believe the error "Publishing changes from within view updates is not allowed, this will cause undefined behavior." comes from here.
                 The location search throws a purple error (memory leak) because it updates an @Published variable, which then affects a List.
                 This article suggested a LazyVStack or a ScrollView instead of a VStack to fix it, but they don't provide the behavior I'm looking for.
                 https://www.donnywals.com/xcode-14-publishing-changes-from-within-view-updates-is-not-allowed-this-will-cause-undefined-behavior/
                 My implementation doesn't seem to do anything absolutely wrong, so I decided to ignore the warning.
                 */
                TextField("Search for a location", text: $localSearchViewData.locationText).focused($locationIsFocused).onTapGesture {
                    showingSearchResults = true
                    locationManager.requestLocation()
                    if let loc = locationManager.location {
                        localSearchViewData.currentLocation = loc
                    }
                }
                
                Button(action: {
                    localSearchViewData.locationText = ""
                }) {
                    Image(systemName: "multiply.circle.fill").foregroundColor(.gray).font(.system(size: 20))
                }
            }.padding(3)
            Divider()
            
            if (showingSearchResults) {
                SwiftUI.List(localSearchViewData.viewData) { place in
                    VStack(alignment: .leading) {
                        Text(place.title)
                        Text(place.subtitle).foregroundColor(.secondary)
                    }.onTapGesture {
                        localSearchViewData.locationText = place.title
                        location = place.title
                        showingSearchResults = false
                        locationIsFocused = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                Spacer()
            }
        }
    }
}
