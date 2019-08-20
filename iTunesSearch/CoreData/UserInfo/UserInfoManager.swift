//
//  UserInfoManager.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 20/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation

class UserInfoManager {
    private struct Constant {
        static let lastVisitDate = "lastVisitDate"
    }
    static let shared = UserInfoManager()

    var lastVisitDate: Date? {
        return UserDefaults.standard.value(forKey: Constant.lastVisitDate) as? Date
    }

    private init() {}

    func updateLastVisitDate() {
        UserDefaults.standard.setValue(Date(), forKeyPath: Constant.lastVisitDate)
    }
}
