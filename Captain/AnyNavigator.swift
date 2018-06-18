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
        from anySource: AnySource,
        to anyRoute: AnyRoute
    ) throws

    func dismissAny(
        from anySource: AnySource
    ) throws

    func prepareAny(
        navigation: AnyNavigation
    ) throws

    func anyBuilder(
        for anyRoute: AnyRoute,
        from anySource: AnySource
    ) throws -> NavigationBuilder

    func anyStrategy(
        for anyRoute: AnyRoute,
        from anySource: AnySource
    ) throws -> PresentationStrategy

    /// Do not call directly, for internal use only. Override to customize behavior.
    func anyNextDestination(
        for anyRoute: AnyRoute,
        from anySource: AnySource
    ) throws -> AnyDestination

    /// Do not call directly, for internal use only. Override to customize behavior.
    func anyNextDestinations(
        for anyRoute: AnyRoute,
        from anySource: AnySource
    ) throws -> [AnyDestination]
}
