// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public struct Navigation<Route, Source, Destination>
    where
    Route: AnyNavigationRoute,
    Source: AnyNavigationSource,
    Destination: UIViewController
{
    public let route: Route
    public let source: Source
    public let destination: Destination
}

public struct AnyNavigation {
    public let route: AnyNavigationRoute
    public let source: AnyNavigationSource
    public let destination: UIViewController
}
