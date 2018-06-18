//
//  DeepNavigationBuilder.swift
//  Captain
//
//  Created by Vincent Esche on 6/18/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public class DeepNavigationBuilder {
    public init() {
        // state-less
    }
}

extension DeepNavigationBuilder: NavigationBuilder {
    public func destinations(
        for route: AnyNavigationRoute,
        from source: AnyNavigationSource,
        on navigator: AnyNavigator
        ) throws -> [AnyNavigationDestination] {
        var presentingNavigator: AnyNavigator = navigator
        var destinations: [AnyNavigationDestination] = []
        var source: AnyNavigationSource = source
        var route: AnyNavigationRoute? = route
        while let currentRoute = route {
            let routeType = type(of: currentRoute)
            var navigator = try routeType.anyNavigator(for: source)
            navigator.presentingNavigator = presentingNavigator
            let destination = try navigator.anyNextDestination(
                for: currentRoute,
                from: source
            )
            try navigator.prepareAny(navigation: AnyNavigation(
                route: currentRoute,
                source: source,
                destination: destination
            ))
            destinations.append(destination)
            let subRoute = currentRoute.tail
            guard subRoute != nil else {
                break
            }
            let destinationAsSource = destination
            route = subRoute
            source = destinationAsSource
            presentingNavigator = navigator
        }
        return destinations
    }
}

