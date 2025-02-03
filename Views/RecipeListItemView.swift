//
//  RecipeListItemView.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import SwiftUI

struct RecipeListItemView: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack {
            recipeImage
            VStack {
                recipeName
                recipeCuisine
                Spacer()
            }
        }
        .frame(height: 100)
    }
    
    var recipeCuisine: some View {
        Text(recipe.cuisine)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            .accessibilityHint(recipe.cuisine)
    }
    
    var recipeImage: some View {
        Group {
            if let urlString = recipe.photoUrlStringSmall {
                AsyncImageView(urlString: urlString)
                    .accessibilityHint(String(localized: "Image of \(recipe.name)"))
            } else {
                Image(systemName: "fork.knife.circle")
                    .accessibilityHint(String(localized: "Placeholder image"))
            }
        }
        .frame(width: 100, height: 100)
    }
    
    var recipeName: some View {
        Text(recipe.name)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(2)
            .accessibilityHint(recipe.name)
    }
}

#Preview {
    let recipe = Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        photoUrlStringLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
        photoUrlStringSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        sourceUrlString: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        youtubeUrlString: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
    )
    RecipeListItemView(recipe: recipe)
}
