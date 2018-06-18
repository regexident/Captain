//
//  ShallowNavigationBuilder.swift
//  Captain
//
//  Created by Vincent Esche on 6/18/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public class ShallowNavigationBuilder {
    public init() {
        // state-less
    }
}

extension ShallowNavigationBuilder: NavigationBuilder {
    public func destinations(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource,
        on navigator: AnyNavigator
    ) throws -> [AnyNavigationDestination] {
        let builder = DeepNavigationBuilder()
        let destinations = try builder.destinations(
            for: route,
            from: source,
            on: navigator
        )
        return [destinations.last!]
    }
}
