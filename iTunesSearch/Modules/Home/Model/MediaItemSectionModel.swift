//
//  MediaItemSectionModel.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 17/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxDataSources

struct MediaItemSectionModel {
    var items: [MediaItem]

    init(items: [MediaItem]) {
        self.items = items
    }
}

extension MediaItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return trackId ?? 0
    }
}

extension MediaItemSectionModel: AnimatableSectionModelType {
    var identity: String {
        return "mediaItems"
    }

    typealias Identity = String

    typealias Item = MediaItem

    init(original: MediaItemSectionModel, items: [MediaItem]) {
        self = MediaItemSectionModel(items: items)
    }
}
