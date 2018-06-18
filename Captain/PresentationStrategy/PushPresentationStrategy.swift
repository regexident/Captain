//
//  PushPresentationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

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
