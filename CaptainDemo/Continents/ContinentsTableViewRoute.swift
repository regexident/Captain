//
//  ContinentsTableViewRoute.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

enum ContinentsTableViewRoute {
    enum ContinentOrId {
        case id(Int64)
        case object(Continent)
    }

    case continent(continent: ContinentOrId)
    
    enum Error: Swift.Error {
        case invalid
    }
}

extension ContinentsTableViewRoute: AnyNavigationRoute {
    var tail: AnyNavigationRoute? {
        return nil
    }
}

extension ContinentsTableViewRoute: NavigationRoute {
    typealias Navigator = ContinentsTableViewNavigator
}
