//
//  LocalSearchData.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import Foundation
import MapKit
import Combine

struct LocalSearchData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
    }
}

/**
 `Abstracts the location search away from the view`
 */
final class LocalSearchViewData: ObservableObject {
    private var cancellable: AnyCancellable?

    // Updates whenever it changes (user types in search bar) and performs a search for points of interest.
    // Only start searching when the user has typed in 4+ characters so you don't run a lot of searches on very broad search terms.
    @Published var locationText = "" {
        didSet {
            if (locationText.count > 3) {
                search(text: locationText)
            }
        }
    }
    
    var currentLocation: CLLocationCoordinate2D?
    
    @Published var viewData = [LocalSearchData]()

    var service: LocalSearchService
    
    init() {
        service = LocalSearchService()
        cancellable = service.localSearchPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocalSearchData(mapItem: $0) })
        }
    }
    
    // If we don't have the user's current location, default to Davis, CA.
    private func search(text: String) {
        service.search(searchText: text, center: currentLocation ?? CLLocationCoordinate2D(latitude: 38.56043542143025, longitude: -121.76042214745614))
    }
}
