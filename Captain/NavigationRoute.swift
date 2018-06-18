//
//  NavigationRoute.swift
//  Captain
//
//  Created by Vincent Esche on 5/26/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol AnyNavigationRoute {
    var tail: AnyNavigationRoute? { get }

    static func anyNavigator(for anySource: AnyNavigationSource) throws -> AnyNavigator
}

extension AnyNavigationRoute {
    public var destinationRoute: AnyNavigationRoute {
        var route: AnyNavigationRoute = self
        while let subRoute = route.tail {
            route = subRoute
        }
        return route
    }
}

public protocol NavigationRoute: AnyNavigationRoute {
    associatedtype Navigator: Captain.Navigator

    static func navigator(for source: Navigator.Source) throws -> Navigator
}

extension NavigationRoute {
    public static func navigator(for source: Navigator.Source) throws -> Navigator {
        return Navigator.attached(to: source)
    }

    public static func anyNavigator(for anySource: AnyNavigationSource) throws -> AnyNavigator {
        guard let source = anySource as? Navigator.Source else {
            throw NavigationError.invalidSource(
                expected: Navigator.Source.self,
                found: type(of: anySource)
            )
        }
        return try self.navigator(for: source)
    }
}
