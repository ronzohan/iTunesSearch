//
//  Result.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

protocol MediaItemProtocol {
    var wrapperType: WrapperType? { get }
    var trackId: Int? { get }
    var kind: Kind? { get }
    var artistName: String? { get }
    var collectionName: String? { get }
    var collectionPrice: Double? { get }
    var collectionHDPrice: Double? { get }
    var country: String? { get }
    var currency: String? { get }
    var trackName: String? { get }
    var trackRentalPrice: Double? { get }
    var trackPrice: Double? { get }
    var lastVisitDate: Date? { get }
    var artworkUrl60: String? { get }
    var artworkUrl100: String? { get }
    var primaryGenreName: String? { get }
    var longDescription: String? { get }
}

struct MediaItem: Codable, MediaItemProtocol, Equatable {
    let wrapperType: WrapperType?
    let trackId: Int?
    let kind: Kind?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let collectionHDPrice: Double?
    let trackHDPrice: Double?
    let longDescription: String?
    let trackRentalPrice: Double?
    let trackHDRentalPrice: Double?

    var lastVisitDate: Date? {
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case trackId
        case wrapperType
        case kind
        case artistName
        case collectionName
        case trackName
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case trackPrice
        case country
        case currency
        case primaryGenreName
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case longDescription
        case trackRentalPrice
        case trackHDRentalPrice = "trackHdRentalPrice"
    }
}

enum Explicitness: String, Codable {
    case explicit
    case notExplicit
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case podcast = "podcast"
    case song = "song"
    case tvEpisode = "tv-episode"
    case musicVideo = "music-video"
}

enum WrapperType: String, Codable {
    case audiobook
    case track
}
