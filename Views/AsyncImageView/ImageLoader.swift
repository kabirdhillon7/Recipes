//
//  ImageLoader.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/30/25.
//

import Foundation
import os
import UIKit

/// A class for asynchronously loading and caching images.
@MainActor
class ImageLoader {
    
    // MARK: - Properties
    
    static let shared = ImageLoader()
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AsyncImageView.ViewModel.self)
    )
    
    // MARK: - Methods
    
    /// Adds an image to the cache for a given string
    func addImage(image: UIImage, nameString: String) {
        imageCache.setObject(image, forKey: NSString(string: nameString))
        Self.logger.trace("Image added to cache: \(nameString)")
    }
    
    /// Fetches an image asynchronously
    func fetchImage(urlString: String) async throws -> UIImage {
        if let cachedImage = getImage(nameString: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            Self.logger.warning("Invalid URL: \(urlString)")
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uuImage = UIImage(data: data) else {
            Self.logger.warning("Failed to decode image from data from: \(urlString)")
            throw URLError(.badServerResponse)
        }
        
        addImage(image: uuImage, nameString: urlString)
        Self.logger.notice("Successfully fetched and cached image from: \(urlString)")
        return uuImage
    }
    
    /// Retrieves an image from the cache for a given string
    func getImage(nameString: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: nameString))
    }
    
    /// Removes an image from the cache for a given string
    func removeImage(nameString: String) {
        imageCache.removeObject(forKey: NSString(string: nameString))
        Self.logger.trace("Image removed from cache for: \(nameString)")    }
}
