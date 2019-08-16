//
//  APIManager.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift

class BaseAPIManager {
    let apiClient: APIClient

    init(client: APIClient = APIClient(baseURL: APIConfig.shared.baseURL,
                                       authManager: AuthManager.shared)) {
        apiClient = client
    }

    func send<T: Codable>(endpoint: Endpoint, parameters: [String: Any]) -> Observable<Result<T, Error>> {
        let request = APIRequest(endpoint: endpoint, parameters: parameters)
        return apiClient.send(request: request)
    }
}

class APIManager: BaseAPIManager {
    static let shared = APIManager()

    func searchItunesFor(term: String,
                         country: String,
                         media: MediaType) -> Observable<Result<SearchResponse, Error>> {
        enum Parameters: String {
            case term
            case country
            case media
        }

        let parameters: [String: Any] = [
            Parameters.term.rawValue: term,
            Parameters.country.rawValue: country,
            Parameters.media.rawValue: media.rawValue
        ]

        return send(endpoint: SearchEndpoint.search, parameters: parameters)
    }
}
