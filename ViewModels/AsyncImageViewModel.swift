//
//  ViewModel.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/30/25.
//

import os
import SwiftUI

extension AsyncImageView {
    
    /// A View Model for `AsyncImageView`
    @Observable
    final class ViewModel {
        
        // MARK: - Properties
        
        var imageLoader: ImageLoader
        private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: AsyncImageView.ViewModel.self)
        )
        
        // MARK: - Init
        
        init(imageLoader: ImageLoader) {
            self.imageLoader = imageLoader
        }
        
        // MARK: - Methods
        
        /// Retrieves an image asynchronously for a given url string
        @MainActor
        func getImage(nameString: String) async -> UIImage? {
            do {
                return try await imageLoader.fetchImage(urlString: nameString)
            } catch let error {
                Self.logger.warning("\(error.localizedDescription, privacy: .public)")
                return UIImage(systemName: "fork.knife.circle")
            }
        }
    }
}
