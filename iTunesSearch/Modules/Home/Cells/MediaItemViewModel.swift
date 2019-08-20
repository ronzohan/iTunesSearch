//
//  MediaItemViewModel.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 20/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

class MediaItemViewModel {
    private let mediaItem: MediaItem

    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
    }

    var trackName: String? {
        return mediaItem.trackName
    }

    var price: String? {
        return "\(mediaItem.currency ?? "AUD") \(mediaItem.trackPrice ?? 0)"
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
