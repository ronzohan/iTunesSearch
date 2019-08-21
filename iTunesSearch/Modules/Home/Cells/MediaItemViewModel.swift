//
//  MediaItemViewModel.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 20/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

class MediaItemViewModel {
    let mediaItem: MediaItemProtocol

    init(mediaItem: MediaItemProtocol) {
        self.mediaItem = mediaItem
    }

    private let priceFormat = "%.2f"

    var trackName: String? {
        return mediaItem.trackName
    }

    var buyPrice: String? {
        guard let price = mediaItem.trackPrice, price != 0 else { return nil }
        return "Buy: \(mediaItem.currency ?? "AUD") \(String(format: priceFormat, price))"
    }

    var rentPrice: String? {
        guard let price = mediaItem.trackRentalPrice, price != 0 else { return nil }
        return "Rent: \(mediaItem.currency ?? "AUD") \(String(format: priceFormat, price))"
    }

    var artistName: String? {
        return mediaItem.artistName
    }

    var imageURL: URL? {
        return URL(string: mediaItem.artworkUrl100 ?? "")
    }

    var genre: String? {
        return mediaItem.primaryGenreName
    }
}

class MediaItemDetailsViewModel: MediaItemViewModel {
    var longDescription: String? {
        return mediaItem.longDescription
    }
}
