//
//  DefaultTabBarNavigationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public class DefaultTabBarNavigationStrategy {
    public let animated: Bool

    public init(animated: Bool = true) {
        self.animated = animated
    }
}

extension DefaultTabBarNavigationStrategy: AnyNavigationStrategy {
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
