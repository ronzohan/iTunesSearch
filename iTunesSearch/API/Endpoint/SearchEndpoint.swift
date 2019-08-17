//
//  AuthEndpoint.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

enum SearchEndpoint {
    case search
}

extension SearchEndpoint: Endpoint {
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    var method: HTTPMethod {
        return .get
    }
}
