//
//  URLSessionProtocol.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskProtocol
}

// Made URLSession to conform to this protocol so that it can be tested
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskProtocol {
        let sessionDataTask = dataTask(with: request,
                                       completionHandler: completionHandler) as URLSessionDataTask
        return sessionDataTask as URLSessionDataTaskProtocol
    }
}
