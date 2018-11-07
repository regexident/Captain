// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public class TabBarPresentationStrategy {
    public let animated: Bool

    public init(animated: Bool = true) {
        self.animated = animated
    }
}

extension TabBarPresentationStrategy: PresentationStrategy {
    public func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws {
        let maybeController = source.tabBarController ?? (source as? UITabBarController)
        guard let tabBarController = maybeController else {
            throw NavigationError.missingTabBarController
        }
        let selectedViewController = tabBarController.selectedViewController
        guard let navigationController = selectedViewController as? UINavigationController else {
            throw NavigationError.missingNavigationController
        }
        let viewControllers = destinations
        navigationController.setViewControllers(
            viewControllers,
            animated: self.animated
        )
    }
}
