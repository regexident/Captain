//
//  NavigationBuilder.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol NavigationBuilder {
    func destinations(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource,
        on navigator: AnyNavigator
    ) throws -> [AnyNavigationDestination]
}
