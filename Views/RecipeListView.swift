//
//  ContentView.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftData
import SwiftUI

/// A View that displays a list of recipes from the API
struct RecipeListView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) var modelContext
    @State private var viewModel: ViewModel
    @State private var endpointSelection: RecipeEndpoints = .allRecipes
    
    // MARK: - Init
    
    init(modelContext: ModelContext) {
        _viewModel = .init(initialValue: ViewModel(modelContext: modelContext,
                                                   apiCaller: RecipeAPICaller()))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.recipes.isEmpty {
                    contentUnavailable
                } else {
                    recipeList
                }
            }
            .navigationTitle(String(localized: "Recipes"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: Text(String(localized: "Search")))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarMenu
                }
            }
            .onAppear {
                viewModel.loadRecipes()
                if viewModel.recipes.isEmpty {
                    Task {
                        await viewModel.getRecipesList()
                    }
                }
            }
            .onChange(of: viewModel.endpointSelection) { _, _ in
                Task {
                    await viewModel.getRecipesList()
                }
            }
            .alert(String(localized: "Error Loading Recipes"), isPresented: $viewModel.presentErrorMessage) {
                Button(String(localized: "OK")) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unable to load recipes.")
            }
        }
    }
    
    /// A View shown when there are no recipes available
    var contentUnavailable: some View {
        ContentUnavailableView(String(localized: "Recipes Unavailable"), systemImage: "xmark.circle", description: Text(String(localized: "No recipes are available.")))
    }
    
    /// A toolbar menu for refreshing and selecting endpoints
    var toolbarMenu: some View {
        Menu {
            Button {
                Task {
                    await viewModel.getRecipesList()
                }
            } label: {
                Label(String(localized: "Refresh"), systemImage: "arrow.clockwise")
            }

            Picker(selection: $viewModel.endpointSelection) {
                ForEach(RecipeEndpoints.allCases) {
                    Text($0.displayName())
                }
            } label: {
                Label(String(localized: "Select Endpoint"), systemImage: "externaldrive.badge.wifi")
            }
            .pickerStyle(.menu)
        } label: {
            Image(systemName: "ellipsis.circle")
        }

    }
    
    /// A list of recipes
    var recipeList: some View {
        List(viewModel.searchedRecipes, id: \.id) {
            RecipeListItemView(recipe: $0)
        }
    }
}
