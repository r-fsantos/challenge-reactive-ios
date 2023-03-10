//
//  NetworkServiceError.swift
//  FinanceApp
//
//  Created by Renato F. dos Santos Jr on 09/03/23.
//

import Foundation

enum NetworkServiceError: Error {
    case decodeError
    case noData
    case invalidURL
    case invalidStatusCode
    case networkError
}

extension NetworkServiceError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .decodeError:
            return "Error during data decoding"
        case .noData:
            return "Data error"
        case .invalidURL:
            return "Invalid URL"
        case .invalidStatusCode:
            return "Invalid status code"
        case .networkError:
            return "An error has occurred. Please verify your connection."
        }
    }
}
