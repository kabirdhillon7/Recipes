//
//  Recipe.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import Foundation
import SwiftData


/// Represents the response containing a list of recipes fetched from the API endpoint
struct RecipeResponse: Codable, Sendable {
    let recipes: [Recipe]
}

/// Represents a recipe
@Model
final class Recipe: Codable, Identifiable, Sendable {
    var cuisine: String
    var name: String
    var photoUrlStringLarge: String?
    var photoUrlStringSmall: String?
    var uuid: String
    var sourceUrlString: String?
    var youtubeUrlString: String?
    
    private enum CodingKeys: String, CodingKey {
        case cuisine, name, uuid
        case photoUrlStringLarge = "photo_url_large"
        case photoUrlStringSmall = "photo_url_small"
        case sourceUrlString = "source_url"
        case youtubeUrlString = "youtube_url"
    }

    init(cuisine: String, name: String, photoUrlStringLarge: String, photoUrlStringSmall: String, uuid: String, sourceUrlString: String, youtubeUrlString: String) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlStringLarge = photoUrlStringLarge
        self.photoUrlStringSmall = photoUrlStringSmall
        self.uuid = uuid
        self.sourceUrlString = sourceUrlString
        self.youtubeUrlString = youtubeUrlString
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
        self.name = try container.decode(String.self, forKey: .name)
        self.photoUrlStringLarge = try container.decodeIfPresent(String.self, forKey: .photoUrlStringLarge) ?? ""
        self.photoUrlStringSmall = try container.decodeIfPresent(String.self, forKey: .photoUrlStringSmall) ?? ""
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.sourceUrlString = try container.decodeIfPresent(String.self, forKey: .sourceUrlString) ?? ""
        self.youtubeUrlString = try container.decodeIfPresent(String.self, forKey: .youtubeUrlString) ?? ""
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(photoUrlStringLarge, forKey: .photoUrlStringLarge)
        try container.encodeIfPresent(photoUrlStringSmall, forKey: .photoUrlStringSmall)
        try container.encode(uuid, forKey: .uuid)
        try container.encodeIfPresent(sourceUrlString, forKey: .sourceUrlString)
        try container.encodeIfPresent(youtubeUrlString, forKey: .youtubeUrlString)
    }
}
