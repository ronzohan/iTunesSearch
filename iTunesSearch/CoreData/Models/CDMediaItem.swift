//
//  CDMediaItem.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 18/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import CoreData

extension CDMediaItem: MediaItemProtocol {
    var trackId: Int? {
        return cdTrackId == 0 ? nil : Int(cdTrackId)
    }

    var trackPrice: Double? {
        return cdTrackPrice
    }

    var kind: Kind? {
        guard let wrapperTypeString = wrapperTypeString else { return nil }
        return Kind(rawValue: wrapperTypeString)
    }

    var trackRentalPrice: Double? {
        return self.cdTrackRentalPrice
    }

    var wrapperType: WrapperType? {
        if let wrapperTypeString = wrapperTypeString {
            return WrapperType(rawValue: wrapperTypeString)
        } else {
            return nil
        }
    }

    var collectionPrice: Double? {
        return cdCollectionPrice
    }

    var collectionHDPrice: Double? {
        return cdCollectionHDPrice
    }

    func updateWith(mediaItem: MediaItemProtocol) {
        self.cdTrackId = Int64(mediaItem.trackId ?? 0)
        self.wrapperTypeString = mediaItem.wrapperType?.rawValue
        self.kindString = mediaItem.kind?.rawValue
        self.artistName = mediaItem.artistName
        self.collectionName = mediaItem.collectionName
        self.trackName = mediaItem.trackName
        self.artworkUrl60 = mediaItem.artworkUrl60
        self.artworkUrl100 = mediaItem.artworkUrl100
        self.cdCollectionPrice = mediaItem.collectionPrice ?? 0
        self.country = mediaItem.country
        self.currency = mediaItem.currency
        self.primaryGenreName = mediaItem.primaryGenreName
        self.cdCollectionHDPrice = mediaItem.collectionHDPrice ?? 0
        self.cdTrackRentalPrice = mediaItem.trackRentalPrice ?? 0
        self.longDescription = mediaItem.longDescription
        self.cdTrackPrice = mediaItem.trackPrice ?? 0
    }
}
