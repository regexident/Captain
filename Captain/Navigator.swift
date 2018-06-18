//
//  Navigator.swift
//  Captain
//
//  Created by Vincent Esche on 5/26/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public typealias AnyNavigationSource = UIViewController // & AnyNavigatorHost
public typealias AnyNavigationDestination = UIViewController

public typealias NavigationSource = AnyNavigationSource // UIViewController & NavigatorHost
public typealias NavigationDestination = AnyNavigationDestination

public protocol Navigator: AnyNavigator {
    associatedtype Source: NavigationSource
    associatedtype Route: NavigationRoute
    typealias Destination = NavigationDestination

    /// Creates a navigator for a pre-existing controller.
    init(source: Source)

    /// Navigates to a given relative `route` from `source`.
    func navigate(
        from source: Source,
        to route: Route
    ) throws

    /// Dismisses the
    func dismiss(
        from source: Source
    ) throws

    func dismiss(
        from source: Source,
        completion: (() -> Void)?
    ) throws

    func prepare(navigation: Navigation<Route, Source, Destination>) throws
    
    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination
}

// MARK: - Navigator: Navigator (Default Implementations)

extension Navigator {
    public static func attached(to source: Source) -> Self {
        guard let navigator = source.anyNavigator as? Self else {
            let navigator = Self(source: source)
            source.anyNavigator = navigator
            return navigator
        }
        return navigator
    }

    public func navigate(
        from source: Source,
        to route: Route
    ) throws {
        let builder = try self.anyBuilder(for: route, from: source)
        let destinations = try builder.destinations(for: route, from: source, on: self)

        let strategy = try self.anyStrategy(for: route, from: source)
        try strategy.present(destinations, from: source)
    }

    public func dismiss(from source: Source) throws {
        try self.dismiss(from: source, completion: nil)
    }

    public func dismiss(from source: Source, completion: (() -> Void)?) throws {
        source.dismiss(animated: false, completion: completion)
    }

    public func withTyped<T>(
        source: AnyNavigationSource,
        closure: (Source) throws -> T
    ) throws -> T {
        guard let safeSource = source as? Source else {
            throw NavigationError.invalidSource(
                expected: Source.self,
                found: type(of: source)
            )
        }
        return try closure(safeSource)
    }

    public func withTyped<T>(
        source: AnyNavigationSource,
        route: AnyNavigationRoute,
        closure: (Source, Route) throws -> T
    ) throws -> T {
        return try self.withTyped(source: source) { safeSource in
            guard let safeRoute = route as? Route else {
                throw NavigationError.invalidRoute(
                    expected: Route.self,
                    found: type(of: route)
                )
            }
            return try closure(safeSource, safeRoute)
        }
    }
}

// MARK: - Navigator: AnyNavigator (Default Implementations)

extension Navigator {
    public func navigateAny(
        from source: AnyNavigationSource,
        to route: AnyNavigationRoute
    ) throws {
        return try self.withTyped(source: source, route: route) { source, route in
            return try self.navigate(from: source, to: route)
        }
    }

    func dismissAny(
        from source: AnyNavigationSource
    ) throws {
        return try self.withTyped(source: source) { source in
            return try self.dismiss(from: source)
        }
    }

    public func anyNextDestination(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource
    ) throws -> AnyNavigationDestination {
        return try self.withTyped(source: source, route: route) { source, route in
            return try self.nextDestination(for: route, from: source)
        }
    }

    public func anyNextDestinations(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource
    ) throws -> [AnyNavigationDestination] {
        return try self.withTyped(source: source, route: route) { source, route in
            return try self.anyNextDestinations(for: route, from: source)
        }
    }

    public func prepareAny(navigation: AnyNavigation) throws {
        try self.withTyped(source: navigation.source, route: navigation.route) { source, route in
            let destination = navigation.destination
            try self.prepare(navigation: Navigation(
                route: route,
                source: source,
                destination: destination
            ))
        }
    }
}
