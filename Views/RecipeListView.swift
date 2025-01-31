//
//  ContentView.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftData
import SwiftUI

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
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.recipes.isEmpty {
                    contentUnavailable
                } else {
                    recipeList
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: Text("Search"))
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
            .alert("Error Loading Recipes", isPresented: $viewModel.presentErrorMessage) {
                Button("OK") { }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    Text("Unable to load recipes.")
                }
            }
        }
    }
    
    var contentUnavailable: some View {
        ContentUnavailableView("Recipes Unavailable", systemImage: "xmark.circle", description: Text("No recipes are available."))
    }
    
    var toolbarMenu: some View {
        Menu {
            Button {
                Task {
                    await viewModel.getRecipesList()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }

            Picker(selection: $viewModel.endpointSelection) {
                ForEach(RecipeEndpoints.allCases) {
                    Text($0.displayName())
                }
            } label: {
                Label("Select Endpoint", systemImage: "externaldrive.badge.wifi")
            }
            .pickerStyle(.menu)
        } label: {
            Image(systemName: "ellipsis.circle")
        }

    }
    
    var recipeList: some View {
        List(viewModel.searchedRecipes, id: \.id) {
            RecipeListItemView(recipe: $0)
        }
    }
}
