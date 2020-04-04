//
//  AppInfo.swift
//  Doughy
//
//  Created by urickg on 4/4/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
