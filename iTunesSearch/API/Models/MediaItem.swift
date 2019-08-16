//
//  Result.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

// MARK: - Result
struct MediaItem: Codable {
    let wrapperType: WrapperType
    let kind: Kind?
    let artistID, collectionID, trackID: Int?
    let artistName: String
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewURL: String?
    let collectionViewURL: String?
    let trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    //let releaseDate: Date?
    let collectionExplicitness: Explicitness
    let trackExplicitness: Explicitness?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String
    let currency: String
    let primaryGenreName: String
    let isStreamable: Bool?
    let collectionArtistID: Int?
    let collectionArtistViewURL: String?
    let collectionHDPrice: Double?
    let trackHDPrice: Double?
    let contentAdvisoryRating: String?
    let shortDescription: String?
    let longDescription: String?
    let hasITunesExtras: Bool?
    let trackRentalPrice: Double?
    let trackHDRentalPrice: Double?
    let copyright: String?
    let resultDescription: String?
    let feedURL: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
    let amgArtistID: Int?
    let collectionArtistName: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName
        case collectionName
        case trackName
        case collectionCensoredName
        case trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case trackPrice
        //case releaseDate
        case collectionExplicitness
        case trackExplicitness
        case discCount
        case discNumber
        case trackCount
        case trackNumber
        case trackTimeMillis
        case country
        case currency
        case primaryGenreName
        case isStreamable
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case contentAdvisoryRating
        case shortDescription
        case longDescription
        case hasITunesExtras
        case trackRentalPrice
        case trackHDRentalPrice = "trackHdRentalPrice"
        case copyright
        case resultDescription = "description"
        case feedURL = "feedUrl"
        case artworkUrl600
        case genreIDS = "genreIds"
        case genres
        case amgArtistID = "amgArtistId"
        case collectionArtistName
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
}

enum WrapperType: String, Codable {
    case audiobook
    case track
}
