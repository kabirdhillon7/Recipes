//
//  APIError.swift
//  Recipes
//
//  Created by Kabir Dhillon on 1/29/25.
//

import Foundation

/// An enumeration that represents API errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case emptyData
    case malformedData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .emptyData:
            return "The data response is empty."
        case .malformedData:
            return "The server returned malformed data."
        }
    }
}
