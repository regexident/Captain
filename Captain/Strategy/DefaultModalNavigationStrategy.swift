//
//  DefaultModalNavigationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public class DefaultModalNavigationStrategy {
    public let animated: Bool
    let completion: (() -> Void)?

    public init(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.animated = animated
        self.completion = completion
    }
}

extension DefaultModalNavigationStrategy: AnyNavigationStrategy {
    public func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(
            destinations,
            animated: false
        )
        source.present(
            navigationController,
            animated: self.animated,
            completion: self.completion
        )
    }
}
