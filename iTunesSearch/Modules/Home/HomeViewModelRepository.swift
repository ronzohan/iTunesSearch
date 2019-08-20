//
//  HomeViewModelRepository.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelRepositoryProtocol {
    func searchItunesFor(term: String,
                         country: String,
                         media: MediaType) -> Observable<Result<SearchResponse, Error>>
    func updateVisitDate() -> Observable<Result<Bool, Error>>
    func lastVisitDate() -> Observable<Result<Date?, Error>>
}

class HomeViewModelRepository: HomeViewModelRepositoryProtocol {
    func lastVisitDate() -> Observable<Result<Date?, Error>> {
        return Observable.create({ observer -> Disposable in
            observer.onNext(Result.success(UserInfoManager.shared.lastVisitDate))
            return Disposables.create()
        })
    }

    func updateVisitDate() -> Observable<Result<Bool, Error>> {
        return Observable.create({ observer -> Disposable in
            UserInfoManager.shared.updateLastVisitDate()
            observer.onNext(Result.success(true))
            return Disposables.create()
        })

    }

    func searchItunesFor(term: String,
                         country: String,
                         media: MediaType) -> Observable<Result<SearchResponse, Error>> {
        return APIManager.shared.searchItunesFor(term: term, country: country, media: media)
    }
}
