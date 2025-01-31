//
//  RecipesApp.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftData
import SwiftUI

@main
struct RecipesApp: App {
    
    @State private var container: ModelContainer
    
    init() {
        do {
            let config = ModelConfiguration (for: Recipe.self)
            container = try ModelContainer(for: Recipe.self, configurations: config)
        } catch {
            fatalError("Failed to set up the model container: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            RecipeListView(modelContext: container.mainContext)
                .modelContainer(for: Recipe.self)
        }
    }
}
