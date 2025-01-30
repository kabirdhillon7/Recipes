//
//  DataServicing.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import Foundation

/// A protocol defining the required methods for any data service for fetching recipe data
protocol DataServicing: Sendable {
    /// Fetches recipe data asynchronously
    func fetchRecipeData<T: Codable>(urlString: String, decoderType: T.Type) async throws -> T
}
