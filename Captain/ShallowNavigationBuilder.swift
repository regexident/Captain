// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public class ShallowNavigationBuilder {
    public init() {
        // state-less
    }
}

extension ShallowNavigationBuilder: NavigationBuilder {
    public func destinations(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource,
        on navigator: AnyNavigator
    ) throws -> [AnyNavigationDestination] {
        let builder = DeepNavigationBuilder()
        let destinations = try builder.destinations(
            for: route,
            from: source,
            on: navigator
        )
        return [destinations.last!]
    }
}
