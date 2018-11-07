// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public class PushPresentationStrategy {
    public let animated: Bool

    public init(animated: Bool = true) {
        self.animated = animated
    }
}

extension PushPresentationStrategy: PresentationStrategy {
    public func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws {
        let maybeController = source.navigationController ?? (source as? UINavigationController)
        guard let navigationController = maybeController else {
            throw NavigationError.missingNavigationController
        }
        var viewControllers = navigationController.viewControllers
        viewControllers.append(contentsOf: destinations)
        navigationController.setViewControllers(
            viewControllers,
            animated: self.animated
        )
    }
}
