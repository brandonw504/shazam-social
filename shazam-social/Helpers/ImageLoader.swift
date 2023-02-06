//
//  ImageLoader.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import Foundation
import UIKit

/**
 `Loads and caches a UIImage from a URL.`
 */
class ImageLoader: ObservableObject {
    let url: String?
    
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    init(url: String?) {
        self.url = url
    }
    
    func fetch() {
        guard image == nil && !isLoading else { return }
        
        guard let url = url, let fetchURL = URL(string: url) else {
            errorMessage = "Error: Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let request = URLRequest(url: fetchURL, cachePolicy: .returnCacheDataElseLoad)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    self?.errorMessage = "Error: Bad response with status code \(response.statusCode)"
                } else if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                } else {
                    self?.errorMessage = "Unknown Error"
                }
            }
        }
        
        task.resume()
    }
}
