//
//  AsyncImageView.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/30/25.
//

import SwiftUI

/// A View that represents an asynchronously loads and displays an image
struct AsyncImageView: View {
    
    // MARK: - Properties
    @State private var viewModel = ViewModel(imageLoader: ImageLoader.shared)
    @State private var image: UIImage? = nil
    let urlString: String
    
    // MARK: - Views
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .task {
            image = await viewModel.getImage(nameString: urlString)
        }
    }
}

#Preview {
    AsyncImageView(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
}
