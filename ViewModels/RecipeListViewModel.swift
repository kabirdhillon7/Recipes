//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftData
import SwiftUI

extension RecipeListView {
    
    /// A View Model for `RecipeListView`
    @Observable
    final class ViewModel: Observable {
        
        // MARK: - Properties
        
        var modelContext: ModelContext
        var recipes: [Recipe] = []
        var searchedRecipes: [Recipe] {
            return searchText.isEmpty ? recipes : recipes.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.cuisine.lowercased().contains(searchText.lowercased()) }
        }
        private let apiCaller: DataServicing
        var searchText: String = ""
        private(set) var errorMessage: String?
        var presentErrorMessage: Bool = false
        var endpointSelection: RecipeEndpoints = .allRecipes
        
        // MARK: - Init
        
        init(modelContext: ModelContext, apiCaller: DataServicing) {
            self.modelContext = modelContext
            self.apiCaller = apiCaller
        }
        
        // MARK: - Methods
        
        /// Fetches the list of recipes asynchronously
        @MainActor
        func getRecipesList() async {
            do {
                let urlString = endpointSelection.rawValue
                let decoderType = RecipeResponse.self
                let recipesData = try await apiCaller.fetchRecipeData(urlString: urlString, decoderType: decoderType)
                let recipesFromData = recipesData.recipes
                
                if recipesFromData.isEmpty {
                    recipes = []
                } else {
                    for recipe in recipesFromData where !recipes.contains(where: { $0.id == recipe.id }) {
                        modelContext.insert(recipe)
                    }
                    recipes = recipesFromData
                }
            } catch let error as APIError {
                recipes = []
                presentErrorMessage.toggle()
                errorMessage = "We're having trouble loading the recipes because the data seems incomplete. Please try again."
            } catch {
                recipes = []
                presentErrorMessage.toggle()
                errorMessage = "An unexpected error occurred while loading the recipes. Please try again."
            }
        }
        
        /// Loads recipes from persistence
        func loadRecipes() {
            do {
                let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
                recipes = try modelContext.fetch(descriptor)
            } catch {
                presentErrorMessage.toggle()
                errorMessage = "Something went wrong while loading the recipes. Please try again."
            }
        }
    }
}
