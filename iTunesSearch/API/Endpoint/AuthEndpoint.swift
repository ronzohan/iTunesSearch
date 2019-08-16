//
//  AuthEndpoint.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

enum AuthEndpoint {
    case login
    case register
    case logout
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register-patient"
        case .logout:
            return "/logout"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var authNeeded: Bool {
        switch self {
        case .logout:
            return true
        default:
            return false
        }
    }
}
