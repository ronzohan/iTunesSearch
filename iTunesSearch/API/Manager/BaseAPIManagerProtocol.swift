//
//  BaseAPIManagerProtocol.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseAPIManagerProtocol {
    var apiClient: APIClient { get set }
    func send<T: Codable>(endpoint: Endpoint, parameters: [String: Any]) -> Observable<Result<T, Error>>
}

extension BaseAPIManagerProtocol {
    func send<T: Codable>(endpoint: Endpoint, parameters: [String: Any]) -> Observable<Result<T, Error>> {
        let request = APIRequest(endpoint: endpoint, parameters: parameters)
        return apiClient.send(request: request)
    }
}
