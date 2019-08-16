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
}

class HomeViewModelRepository: HomeViewModelRepositoryProtocol {
    func searchItunesFor(term: String,
                         country: String,
                         media: MediaType) -> Observable<Result<SearchResponse, Error>> {
        return APIManager.shared.searchItunesFor(term: term, country: country, media: media)
    }
}
