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
    private struct Constant {
        static let mediaItemTrackIDKey = "mediaItemTrackIDKey"
    }

    let context: NSManagedObjectContext

    /// Creates a new instance of MediaDetailsRepository with the given NSManagedObjectContext
    /// - Parameter context: Context that will be used for saving data
    init(context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext) {
        self.context = context
    }

    /// Save the media item if it doesn't exist in the database yet or update its value if its
    /// already existing
    ///
    /// - Parameter mediaItem: Media Item
    /// - Returns: Returns the saved MediaItem or an error
    func saveOrUpdate(_ mediaItem: MediaItemProtocol) -> Observable<Result<MediaItemProtocol, Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            do {
                let existingMediaItem: CDMediaItem?
                if let trackId = mediaItem.trackId {
                    existingMediaItem = strongSelf.existingMediaItem(withTrackID: trackId)
                } else {
                    existingMediaItem = nil
                }

                if existingMediaItem == nil {
                    let cdMediaDetail = CDMediaItem(context: strongSelf.context)
                    cdMediaDetail.updateWith(mediaItem: mediaItem)
                    try strongSelf.context.save()
                    UserDefaults.standard.set(cdMediaDetail.trackId,
                                              forKey: Constant.mediaItemTrackIDKey)
                    observer.onNext(Result.success(cdMediaDetail))
                } else if let existingMediaItem = existingMediaItem {
                    existingMediaItem.updateWith(mediaItem: mediaItem)
                    try strongSelf.context.save()
                    observer.onNext(Result.success(existingMediaItem))
                    UserDefaults.standard.set(existingMediaItem.trackId,
                                              forKey: Constant.mediaItemTrackIDKey)
                }
            } catch let error {
                observer.onError(error)
            }

            return Disposables.create()
        })
    }

    func removeMediaItem(withTrackID trackID: Int) -> Observable<Result<Bool, Error>> {
        return Observable.create({ [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            let mediaItemFetchRequest: NSFetchRequest<CDMediaItem> =  CDMediaItem.fetchRequest()
            mediaItemFetchRequest.predicate = NSPredicate(format: "cdTrackId == %d", trackID)
            let mediaItems = try? self.context.fetch(mediaItemFetchRequest)

            if let mediaItem = mediaItems?.first {
                self.context.delete(mediaItem)

                do {
                    try self.context.save()
                    observer.onNext(Result.success(true))
                } catch let error {
                    observer.onNext(Result.failure(error))
                }

            } else {
                observer.onNext(Result.success(false))
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
                observer.onNext(Result.success(true))
            } catch let error {
                observer.onNext(Result.failure(error))
            }

            return Disposables.create()
        })
    }

    func fetchSavedMediaItemTrackId() -> Observable<Result<Int?, Error>> {
        return Observable.create({ observer -> Disposable in
            if let trackID = UserDefaults.standard.value(forKey: Constant.mediaItemTrackIDKey) as? Int {
                observer.onNext(Result.success(trackID))
            } else {
                observer.onNext(Result.success(nil))
            }

            observer.onCompleted()

            return Disposables.create()
        })
    }

    func existingMediaItem(withTrackID trackID: Int) -> CDMediaItem? {
        let mediaItemFetchRequest: NSFetchRequest<CDMediaItem> =  CDMediaItem.fetchRequest()
        mediaItemFetchRequest.predicate = NSPredicate(format: "cdTrackId == %d", trackID)
        let mediaItems = try? context.fetch(mediaItemFetchRequest)
        return mediaItems?.first
    }
}
