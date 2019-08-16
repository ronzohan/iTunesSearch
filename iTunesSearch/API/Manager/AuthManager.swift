//
//  AuthManager.swift
//  Psychia
//
//  Created by Ron Daryl Magno on 25/07/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

protocol AuthManagerProtocol: class {
    var userToken: String? { get set }
    var identifierID: String? { get }
}

class AuthManager: AuthManagerProtocol {
    struct Constant {
        static let userTokenKey = "UserToken"
    }

    static let shared: AuthManager = AuthManager(userDefaults: .standard)

    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userToken: String? {
        get {
            return userDefaults.string(forKey: Constant.userTokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: Constant.userTokenKey)
        }
    }

    var identifierID: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
