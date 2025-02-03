//
//  ViewModel.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/30/25.
//

import SwiftUI

extension AsyncImageView {
    
    /// A View Model for `AsyncImageView`
    @Observable
    final class ViewModel {
        
        // MARK: - Properties
        var imageLoader: ImageLoader
        
        // MARK: - Init
        init(imageLoader: ImageLoader) {
            self.imageLoader = imageLoader
        }
        
        // MARK: - Methods
        
        // Retrieves an image asynchronously for a given url string
        @MainActor
        func getImage(nameString: String) async -> UIImage? {
            do {
                return try await imageLoader.fetchImage(urlString: nameString)
            } catch let error {
                print("AsyncImageView View Model: unable to load image: \(error)")
                return UIImage(systemName: "fork.knife.circle")
            }
        }
    }
}
