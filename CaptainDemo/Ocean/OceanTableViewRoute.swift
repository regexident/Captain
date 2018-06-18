//
//  OceanTableViewRoute.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

enum OceanTableViewRoute {
    enum SeaOrId {
        case id(Int64)
        case object(Sea)
    }
    case sea(sea: SeaOrId)

    enum Error: Swift.Error {
        case invalid
    }
}

extension OceanTableViewRoute: AnyNavigationRoute {
    var tail: AnyNavigationRoute? {
        return nil
    }
}

extension OceanTableViewRoute: NavigationRoute {
    typealias Navigator = OceanTableViewNavigator
}
