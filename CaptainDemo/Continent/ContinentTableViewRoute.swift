//
//  ContinentTableViewRoute.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

enum ContinentTableViewRoute {
    enum CountryOrId {
        case id(Int64)
        case object(Country)
    }
    case country(country: CountryOrId)

    enum Error: Swift.Error {
        case invalid
    }
}

extension ContinentTableViewRoute: AnyNavigationRoute {
    var tail: AnyNavigationRoute? {
        return nil
    }
}

extension ContinentTableViewRoute: NavigationRoute {
    typealias Navigator = ContinentTableViewNavigator
}
