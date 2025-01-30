//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftData
import SwiftUI

extension RecipeListView {
    
    @Observable
    final class ViewModel: Observable {
        
        // MARK: Properties
        var modelContext: ModelContext
        private(set) var recipes: [Recipe] = []
        private let apiCaller: DataServicing
        
        // MARK: Init
        init(modelContext: ModelContext, apiCaller: DataServicing) {
            self.modelContext = modelContext
            self.apiCaller = apiCaller
        }
        
        // MARK: Methods
        
        @MainActor
        func fetchRecipesList() async {
            do {
                let urlString = RecipeEndpoints.allRecipes.rawValue
                let decoderType = RecipeResponse.self
                let recipesData = try await apiCaller.fetchRecipeData(urlString: urlString,
                                                                      decoderType: decoderType)
                recipes = recipesData.recipes
            } catch {
                
            }
        }
    }
}
