//
//  AnyNavigator.swift
//  Captain
//
//  Created by Vincent Esche on 5/26/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol AnyNavigator {
    typealias AnySource = AnyNavigationSource
    typealias AnyRoute = AnyNavigationRoute
    typealias AnyDestination = AnyNavigationDestination

    var presentingNavigator: AnyNavigator? { set get }

    func navigateAny(
        from source: AnySource,
        to route: AnyRoute
    ) throws

    func dismissAny(
        from source: AnySource
    ) throws

    func prepareAny(
        navigation: AnyNavigation
    ) throws

    func anyBuilder(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationBuilder

    func anyStrategy(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationStrategy

    /// Do not call directly, for internal use only. Override to customize behavior.
    func anyNextDestination(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyDestination

    /// Do not call directly, for internal use only. Override to customize behavior.
    func anyNextDestinations(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> [AnyDestination]
}

extension AnyNavigator {
    public func anyBuilder(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationBuilder {
        return DefaultAnyNavigationBuilder()
    }

    public func anyStrategy(
        for route: AnyRoute,
        from source: AnySource
    ) throws -> AnyNavigationStrategy {
        if (source.navigationController ?? (source as? UINavigationController)) != nil {
            return DefaultPushNavigationStrategy()
        } else if (source.tabBarController ?? (source as? UITabBarController)) != nil {
            return DefaultTabBarNavigationStrategy()
        } else {
            return DefaultModalNavigationStrategy()
        }
    }
}
