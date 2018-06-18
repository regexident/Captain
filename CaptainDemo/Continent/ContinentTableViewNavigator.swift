//
//  ContinentTableViewNavigator.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

class ContinentTableViewNavigator {
    var presentingNavigator: AnyNavigator?
    
    init() {
        // state-less navigator
    }

    required convenience init(source: Source) {
        self.init()
    }
}

extension ContinentTableViewNavigator: AnyNavigator {
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

extension ContinentTableViewNavigator: Navigator {
    typealias Source = ContinentTableViewController
    typealias Route = ContinentTableViewRoute

    func prepare(navigation: Navigation<Route, Source, Navigator.Destination>) throws {
        guard let destination = navigation.destination as? CountryReceiver else {
            return
        }
        switch navigation.route {
        case .country(let countryOrId):
            let country: Country
            switch countryOrId {
            case .id(let id):
                guard let object = navigation.source.countryWith(id: id) else {
                    fatalError("Unknown country")
                }
                country = object
            case .object(let object):
                country = object
            }
            destination.set(country: country)
        }
    }

    func nextDestination(
        for route: Route,
        from source: Source
    ) throws -> AnyNavigationDestination {
        switch route {
        case .country(_):
            let storyboard = UIStoryboard(name: "Country", bundle: nil)
            return storyboard.instantiateInitialViewController()!
        }
    }
}

extension ContinentTableViewNavigator: AnyGlobalNavigator {

}

extension ContinentTableViewNavigator: GlobalNavigator {
    typealias RootNavigator = RootTabBarNavigator

    var rootNavigator: RootNavigator {
        return AppDelegate.shared.rootTabBarNavigator
    }
}

extension ContinentTableViewNavigator: ContinentTableViewControllerDelegate {
    func controller(
        _ controller: ContinentTableViewController,
        didSelectCountry country: Country
    ) {
        do {
            try self.navigate(
                from: controller,
                to: .country(country: .object(country))
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func controller(
        _ controller: ContinentTableViewController,
        didSelectOcean ocean: Ocean
    ) {
        do {
            try self.navigate(
                to: .oceans(
                    subRoute: .ocean(ocean: .object(ocean))
                )
            )
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
