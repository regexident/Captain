//
//  OceanTableViewNavigator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

class OceanTableViewNavigator {
    var presentingNavigator: AnyNavigator?

    init() {
        // state-less navigator
    }

    required convenience init(source: Source) {
        self.init()
    }
}

extension OceanTableViewNavigator: AnyNavigator {
    func dismissAny(from source: AnyNavigationSource) throws {
        fatalError()
    }

    public func anyStrategy(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> PresentationStrategy {
        return ModalPresentationStrategy()
    }
}

extension OceanTableViewNavigator: Navigator {
    typealias Source = OceanTableViewController
    typealias Route = OceanTableViewRoute

    func prepare(navigation: Navigation<Route, Source, Navigator.Destination>) throws {
        guard let destination = navigation.destination as? SeaReceiver else {
            return
        }
        switch navigation.route {
        case .sea(let seaOrId):
            let sea: Sea
            switch seaOrId {
            case .id(let id):
                guard let object = navigation.source.seaWith(id: id) else {
                    fatalError("Unknown country")
                }
                sea = object
            case .object(let object):
                sea = object
            }
            destination.set(sea: sea)
        }
    }

    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination {
        switch route {
        case .sea(_):
            let storyboard = UIStoryboard(name: "Sea", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        }
    }
}

extension OceanTableViewNavigator: AnyGlobalNavigator {

}

extension OceanTableViewNavigator: GlobalNavigator {
    typealias RootNavigator = RootTabBarNavigator

    var rootNavigator: RootNavigator {
        let controller = AppDelegate.shared.rootTabBarController
        return RootNavigator.attached(to: controller)
    }
}

extension OceanTableViewNavigator: OceanTableViewControllerDelegate {
    func controller(
        _ controller: OceanTableViewController,
        didSelectSea sea: Sea
    ) {
        do {
            try self.navigate(
                from: controller,
                to: .sea(sea: .object(sea))
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func controller(
        _ controller: OceanTableViewController,
        didSelectContinent continent: Continent
    ) {
        do {
            try self.navigate(
                to: .continents(
                    subRoute: .continent(continent: .object(continent))
                )
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
