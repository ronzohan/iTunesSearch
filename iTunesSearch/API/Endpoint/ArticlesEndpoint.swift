//
//  ArticlesEndpoint.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 26/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

enum ArticlesEndpoint {
    case articles
    case articleDetail(id: Int)
    case information
    case informationDetail(id: Int)
}

extension ArticlesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .articles:
            return "/articles"
        case .articleDetail(let id):
            return "/articles/\(id)"
        case .information:
            return "/information"
        case .informationDetail(let id):
            return "/information/\(id)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var authNeeded: Bool {
        return true
    }
}
