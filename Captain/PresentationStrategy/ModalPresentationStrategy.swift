//
//  ModalPresentationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public class ModalPresentationStrategy {
    public let animated: Bool
    private let completion: (() -> Void)?
    private var presentedViewController: UIViewController?

    public init(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.animated = animated
        self.completion = completion
    }
}

extension ModalPresentationStrategy: PresentationStrategy {
    public func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(
            destinations,
            animated: false
        )
        print("Destinations:", destinations)
        self.presentedViewController = navigationController
        source.present(
            navigationController,
            animated: self.animated,
            completion: {
                self.completion?()
            }
        )
    }
}

extension ModalPresentationStrategy: DismissablePresentationStrategy {
    public func dismiss(from anyDestination: AnyNavigationDestination) throws {
        self.presentedViewController?.dismiss(
            animated: self.animated,
            completion: {
                self.completion?()
            }
        )
    }
}
