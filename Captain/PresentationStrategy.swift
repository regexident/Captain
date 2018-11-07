// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol PresentationStrategy {
    func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws
}

public protocol DismissablePresentationStrategy: PresentationStrategy {
    func dismiss(from anyDestination: AnyNavigationDestination) throws
}
