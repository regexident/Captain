//
//  OceansTableViewRoute.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

enum OceansTableViewRoute {
    enum OceanOrId {
        case id(Int64)
        case object(Ocean)
    }
    case ocean(ocean: OceanOrId)

    enum Error: Swift.Error {
        case invalid
    }
}

extension OceansTableViewRoute: AnyNavigationRoute {
    var tail: AnyNavigationRoute? {
        return nil
    }
}

extension OceansTableViewRoute: NavigationRoute {
    typealias Navigator = OceansTableViewNavigator
}
