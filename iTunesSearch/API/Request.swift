//
//  Request.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

protocol Request {
    var endpoint: Endpoint { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
}

extension Request {
    func urlRequest(withBaseURL baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path),
                                             resolvingAgainstBaseURL: false)
            else {
                fatalError("Unable to create URL components")
        }

        switch endpoint.method {
        case .get:
            // If the method is get then set query items in the components
            if !parameters.isEmpty {
                components.queryItems = parameters.compactMap { (name, value) -> URLQueryItem? in
                    URLQueryItem(name: name, value: "\(value)")
                }
            }

            components.percentEncodedQuery = components
                .percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        default:
            break
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        request.timeoutInterval = TimeInterval(60)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData

        switch endpoint.method {
        case .post:
            if !parameters.isEmpty {
                let parametersArrayString = parameters.compactMap { (key, value) -> String? in
                    "\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                }
                request.httpBody = parametersArrayString.joined(separator: "&").data(using: .utf8)
            }
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        default:
            break
        }

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        return request
    }
}

class APIRequest: Request {
    var endpoint: Endpoint
    var headers: [String: String]
    var parameters: [String: Any]

    init(endpoint: Endpoint, headers: [String: String] = [:], parameters: [String: Any] = [:]) {
        self.endpoint = endpoint
        self.headers = headers
        self.parameters = parameters
    }
}
