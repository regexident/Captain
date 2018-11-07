// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
