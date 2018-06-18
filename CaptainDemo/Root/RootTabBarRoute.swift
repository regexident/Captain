//
//  RootTabBarRoute.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/6/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

import Captain

enum RootTabBarRoute {
    indirect case continents(subRoute: ContinentsTableViewNavigator.Route?)
    indirect case oceans(subRoute: OceansTableViewNavigator.Route?)

    enum Error: Swift.Error {
        case invalid(String)
    }
}

extension RootTabBarRoute: NavigationRoute {
    typealias Navigator = RootTabBarNavigator
}

extension RootTabBarRoute: AnyNavigationRoute {
    var tail: AnyNavigationRoute? {
        switch self {
        case .continents(let tail):
            return tail
        case .oceans(let tail):
            return tail
        }
    }
}

extension RootTabBarRoute: CustomStringConvertible {
    var description: String {
        switch self {
        case .continents(subRoute: let subRoute):
            return "continents/" + (subRoute.map { "\($0)" } ?? "")
        case .oceans(subRoute: let subRoute):
            return "oceans/" + (subRoute.map { "\($0)" } ?? "")
        }
    }
}

//extension RootTabBarRoute: CoordinationRoute {
//    typealias Coordinator = RootCoordinator
//
//    func coordinator() throws -> Coordinator {
//        return AppDelegate.shared.rootCoordinator
//    }
//}
//
//extension RootTabBarRoute: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case first
//        case second
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let firstChild = try? values.decode(FirstViewCoordinator.Route?.self, forKey: .first) {
//            self = .first(firstChild)
//            return
//        }
//        if let secondChild = try? values.decode(SecondViewCoordinator.Route?.self, forKey: .second) {
//            self = .second(secondChild)
//            return
//        }
//        throw Error.invalid("\(dump(values))")
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .first(let firstChild):
//            try container.encode(firstChild, forKey: .first)
//        case .second(let secondChild):
//            try container.encode(secondChild, forKey: .second)
//        }
//    }
//}
//
