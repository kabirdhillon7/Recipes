//
//  RecipeEndpoints.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import Foundation

/// An enumeration represeting the endpoints for the API
enum RecipeEndpoints: String, CaseIterable, Identifiable {
    var id: Self { self }

    case allRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformedData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case emptyData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    func displayName() -> String {
        switch self {
        case .allRecipes:
            return "All Recipes"
        case .malformedData:
            return "Malformed Data"
        case .emptyData:
            return "Empty Data"
        }
    }
}
