//
//  PresentationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

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
