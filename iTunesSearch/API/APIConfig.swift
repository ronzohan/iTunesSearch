//
//  APIConfig.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

class APIConfig {
    static let shared = APIConfig()

    public enum Environment: Int {
        case development
        case production
    }

    private let developmentBaseURL = "https://itunes.apple.com"
    private let productionBaseURL = "https://itunes.apple.com"

    var environment: Environment {
        #if DEVELOPMENT
        return .development
        #else
        return .production
        #endif
    }

    var baseURL: String {
        switch environment {
        case .development:
            return developmentBaseURL
        case .production:
            return productionBaseURL
        }
    }
}
