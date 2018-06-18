//
//  RootTabBarNavigator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/6/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

class RootTabBarNavigator {
    var _source: Source

    var presentingNavigator: AnyNavigator?
    
    required init(source: Source) {
        self._source = source
    }
}

extension RootTabBarNavigator: AnyNavigator {
    func dismissAny(from source: AnyNavigationSource) throws {
        fatalError()
    }

    public func anyStrategy(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationStrategy {
        return DefaultTabBarNavigationStrategy()
    }
}

extension RootTabBarNavigator: Navigator {
    typealias Source = RootTabBarController
    typealias Route = RootTabBarRoute

    func prepare(navigation: Navigation<Route, Source, Navigator.Destination>) throws {
        switch navigation.route {
        case .continents(_):
            guard let destination = navigation.destination as? ContinentsTableViewController else {
                return
            }
            destination.managedObjectContext = navigation.source.managedObjectContext
        case .oceans(_):
            guard let destination = navigation.destination as? OceansTableViewController else {
                return
            }
            destination.managedObjectContext = navigation.source.managedObjectContext
        }
    }

    func navigate(from source: Source, to route: Route) throws {
        let selectedIndex: Int
        switch route {
        case .continents(_):
            selectedIndex = 0
        case .oceans(_):
            selectedIndex = 1
        }
        source.selectedIndex = selectedIndex

        let builder = try self.anyBuilder(for: route, from: source)
        let destinations = try builder.destinations(for: route, from: source, on: self)

        let strategy = try self.anyStrategy(for: route, from: source)
        try strategy.present(destinations, from: source)
    }

    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination {
        switch route {
        case .continents(_):
            let storyboard = UIStoryboard(name: "Continents", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        case .oceans(_):
            let storyboard = UIStoryboard(name: "Oceans", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        }
    }
}

extension RootTabBarNavigator: GlobalNavigator {
    typealias RootNavigator = RootTabBarNavigator

    var rootNavigator: RootNavigator {
        return self
    }

    func navigate(to route: RootNavigator.Route) throws {
        try self.navigate(
            from: self.source,
            to: route
        )
    }
}

extension RootTabBarNavigator: RootNavigator {
    var source: Source {
        return self._source
    }
}
