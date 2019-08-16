//
//  SearchResponse.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

// MARK: - Response
struct SearchResponse: Codable {
    let resultCount: Int
    let results: [MediaItem]
}
