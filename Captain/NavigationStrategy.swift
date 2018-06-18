//
//  AnyNavigationStrategy.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol AnyNavigationStrategy {
    func present(
        _ destinations: [AnyNavigationDestination],
        from source: AnyNavigationSource
    ) throws
}

public protocol NavigationStrategy {
    associatedtype Source: NavigationSource

    func present(
        _ destinations: [AnyNavigationDestination],
        from source: Source
    ) throws
}
