//
//  NetworkError.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)
    
    var errorDescription : String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data"
        case .decodingError:
            return "Decoding error"
        case .serverError(let Int):
            return "Server error"
        case .unknown(let error):
            return "Server error"

        }
    }
}
