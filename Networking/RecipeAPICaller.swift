//
//  RecipeAPICaller.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import Foundation

/// A struct responsible for calling the API to fetch recipe data
struct RecipeAPICaller: DataServicing {
    
    /// Fetches recipe data from the API
    func fetchRecipeData<T: Codable>(urlString: String, decoderType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(decoderType.self, from: data)
        } catch {
            throw APIError.malformedData
        }
    }
}
