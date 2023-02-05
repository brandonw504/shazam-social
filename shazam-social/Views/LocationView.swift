//
//  LocationView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI

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
