//
//  MediaDetailsRepository.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 19/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class MediaDetailsRepository {
    let context = CoreDataManager.shared.persistentContainer.viewContext

    func saveMediaItem(_ mediaItem: MediaItemProtocol) -> Observable<Result<MediaItemProtocol, Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            do {
                let existingMediaItem: CDMediaItem?
                if let trackId = mediaItem.trackId {
                    existingMediaItem = strongSelf.isExistingMediaItem(withTrackID: trackId)
                } else {
                    existingMediaItem = nil
                }

                if existingMediaItem == nil {
                    let cdMediaDetail = CDMediaItem(context: strongSelf.context)
                    cdMediaDetail.updateWith(mediaItem: mediaItem)
                    try strongSelf.context.save()
                    observer.onNext(Result.success(cdMediaDetail))
                } else if let existingMediaItem = existingMediaItem {
                    observer.onNext(Result.success(existingMediaItem))
                }
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        })
    }

    func setMediaItemVisitDate(withTrackID trackID: Int,
                               date: Date) -> Observable<Result<Bool, Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            do {
                let mediaItemFetchRequest: NSFetchRequest<CDMediaItem> =  CDMediaItem.fetchRequest()
                mediaItemFetchRequest.predicate = NSPredicate(format: "cdTrackId == %d", trackID)

                let mediaItem = try self?.context.fetch(mediaItemFetchRequest).first
                mediaItem?.lastVisitDate = date

                try self?.context.save()
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        })
    }

    func isExistingMediaItem(withTrackID trackID: Int) -> CDMediaItem? {
        let mediaItemFetchRequest: NSFetchRequest<CDMediaItem> =  CDMediaItem.fetchRequest()
        mediaItemFetchRequest.predicate = NSPredicate(format: "cdTrackId == %d", trackID)
        let mediaItems = try? context.fetch(mediaItemFetchRequest)
        return mediaItems?.first
    }
}
