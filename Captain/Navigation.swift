//
//  Navigation.swift
//  Captain
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public struct Navigation<Route, Source, Destination>
    where
    Route: AnyNavigationRoute,
    Source: AnyNavigationSource,
    Destination: UIViewController
{
    public let route: Route
    public let source: Source
    public let destination: Destination
}

public struct AnyNavigation {
    public let route: AnyNavigationRoute
    public let source: AnyNavigationSource
    public let destination: UIViewController
}
