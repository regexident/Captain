//
//  OceansTableViewNavigator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

class OceansTableViewNavigator {
    var presentingNavigator: AnyNavigator?
    
    init() {
        // state-less navigator
    }

    required convenience init(source: Source) {
        self.init()
    }
}

extension OceansTableViewNavigator: AnyNavigator {
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

extension OceansTableViewNavigator: Navigator {
    typealias Source = OceansTableViewController
    typealias Route = OceansTableViewRoute

    func prepare(navigation: Navigation<Route, Source, Navigator.Destination>) throws {
        guard let destination = navigation.destination as? OceanReceiver else {
            return
        }
        switch navigation.route {
        case .ocean(let oceanOrId):
            let ocean: Ocean
            switch oceanOrId {
            case .id(let id):
                guard let object = navigation.source.oceanWith(id: id) else {
                    fatalError("Unknown ocean")
                }
                ocean = object
            case .object(let object):
                ocean = object
            }
            guard let context = navigation.source.managedObjectContext else {
                fatalError("Expected `self.managedObjectContext`, found `nil`.")
            }
            destination.set(managedObjectContext: context)
            destination.set(ocean: ocean)
        }
    }

    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination {
        switch route {
        case .ocean(_):
            let storyboard = UIStoryboard(name: "Ocean", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        }
    }
}

extension OceansTableViewNavigator: AnyGlobalNavigator {

}

extension OceansTableViewNavigator: GlobalNavigator {
    typealias RootNavigator = RootTabBarNavigator

    var rootNavigator: RootNavigator {
        let controller = AppDelegate.shared.rootTabBarController
        return RootNavigator.attached(to: controller)
    }
}

extension OceansTableViewNavigator: OceansDelegate {
    func controller(
        _ controller: OceansTableViewController,
        didSelectOcean ocean: Ocean
    ) {
        do {
            try self.navigate(
                from: controller,
                to: .ocean(ocean: .id(ocean.id))
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
