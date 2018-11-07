// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
