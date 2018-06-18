//
//  NavigationError.swift
//  Captain
//
//  Created by Vincent Esche on 5/26/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import Foundation

public enum NavigationError {
    case invalidSource(expected: Any.Type, found: Any.Type)
    case invalidRoute(expected: Any.Type, found: Any.Type)
    case invalidDestination(expected: Any.Type, found: Any.Type)
    case invalidNavigator(expected: Any.Type, found: Any.Type)

    case missingNavigationController
    case missingTabBarController
    case other(Swift.Error)
}

extension NavigationError: Error {
    public var localizedDescription: String {
        switch self {
        case .invalidSource(let expected, let found):
            return "Expected `\(expected)`, found `\(found)`."
        case .invalidRoute(let expected, let found):
            return "Expected `\(expected)`, found `\(found)`."
        case .invalidDestination(let expected, let found):
            return "Expected `\(expected)`, found `\(found)`."
        case .invalidNavigator(let expected, let found):
            return "Expected `\(expected)`, found `\(found)`."
        case .missingNavigationController:
            return "Missing UINavigationController."
        case .missingTabBarController:
            return "Missing UITabBarController."
        case .other(let error):
            return error.localizedDescription
        }
    }
}
