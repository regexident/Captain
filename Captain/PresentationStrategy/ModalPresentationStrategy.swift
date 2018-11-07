// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
