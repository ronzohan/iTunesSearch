//
//  ResponseInfo.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

struct ResponseInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case error
    }

    let success: Bool?
    let message: String?
    let error: String?

    init(success: Bool?, message: String?, error: String? = nil) {
        self.success = success
        self.message = message
        self.error = error
    }
}
