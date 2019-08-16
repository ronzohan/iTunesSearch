//
//  URLSessionDataTaskProtocol.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 22/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

// Made URLSessionDataTask to conform to this protocol so that it can be tested
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
