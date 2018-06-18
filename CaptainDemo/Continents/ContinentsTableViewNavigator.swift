//
//  ContinentsTableViewNavigator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

class ContinentsTableViewNavigator {
    var presentingNavigator: AnyNavigator?

    init() {
        // state-less navigator
    }

    required convenience init(source: Source) {
        self.init()
    }
}

extension ContinentsTableViewNavigator: AnyNavigator {
    func dismissAny(from source: AnyNavigationSource) throws {
        fatalError()
    }

    public func anyStrategy(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationStrategy {
        return DefaultPushNavigationStrategy()
    }
}

extension ContinentsTableViewNavigator: Navigator {
    typealias Source = ContinentsTableViewController
    typealias Route = ContinentsTableViewRoute

    func prepare(navigation: Navigation<Route, Source, Navigator.Destination>) throws {
        guard let destination = navigation.destination as? ContinentReceiver else {
            return
        }
        switch navigation.route {
        case .continent(let continentOrId):
            let continent: Continent
            switch continentOrId {
            case .id(let id):
                guard let object = navigation.source.continentWith(id: id) else {
                    fatalError("Unknown country")
                }
                continent = object
            case .object(let object):
                continent = object
            }
            guard let context = navigation.source.managedObjectContext else {
                fatalError("Expected `self.managedObjectContext`, found `nil`.")
            }
            destination.set(managedObjectContext: context)
            destination.set(continent: continent)
        }
    }

    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination {
        switch route {
        case .continent(_):
            let storyboard = UIStoryboard(name: "Continent", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        }
    }
}

extension ContinentsTableViewNavigator: AnyGlobalNavigator {

}

extension ContinentsTableViewNavigator: GlobalNavigator {
    typealias RootNavigator = RootTabBarNavigator

    var rootNavigator: RootNavigator {
        let controller = AppDelegate.shared.rootTabBarController
        return RootNavigator.attached(to: controller)
    }
}

extension ContinentsTableViewNavigator: ContinentsDelegate {
    func controller(
        _ controller: ContinentsTableViewController,
        didSelectContinent continent: Continent
    ) {
        do {
            try self.navigate(
                from: controller,
                to: .continent(continent: .id(continent.id))
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
