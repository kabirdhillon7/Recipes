//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import os
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
        private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: RecipeListView.ViewModel.self)
        )
        
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
                Self.logger.trace("Start recipe list fetching.")
                let recipesData = try await apiCaller.fetchRecipeData(urlString: urlString, decoderType: decoderType)
                let recipesFromData = recipesData.recipes
                
                if recipesFromData.isEmpty {
                    recipes = []
                    Self.logger.notice("Recipe list is empty from fetching.")
                } else {
                    for recipe in recipesFromData where !recipes.contains(where: { $0.id == recipe.id }) {
                        modelContext.insert(recipe)
                    }
                    recipes = recipesFromData
                    Self.logger.notice("Recipe list fetching complete.")
                }
            } catch let error as APIError {
                recipes = []
                logError(error: error, message: "We're having trouble loading the recipes because the data seems incomplete. Please try again.")
            } catch {
                recipes = []
                logError(error: error, message: "An unexpected error occurred while loading the recipes. Please try again.")
            }
        }
        
        /// Loads recipes from persistence
        func loadRecipes() {
            do {
                let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
                recipes = try modelContext.fetch(descriptor)
                Self.logger.notice("Recipe list fetching complete from SwiftData persistence.")
            } catch {
                logError(error: error, message: "Something went wrong while loading the recipes. Please try again.")
            }
        }
        
        /// Logs an error
        private func logError(error: Error, message: String) {
            presentErrorMessage.toggle()
            errorMessage = message
            Self.logger.warning("\(error.localizedDescription, privacy: .public)")
        }
    }
}
