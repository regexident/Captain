//
//  GlobalNavigator.swift
//  Captain
//
//  Created by Vincent Esche on 5/26/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol AnyGlobalNavigator: AnyNavigator {
    var anyRootNavigator: AnyNavigator { get }
}

public protocol GlobalNavigator: AnyGlobalNavigator, Navigator {
    associatedtype RootNavigator: Captain.RootNavigator

    var rootNavigator: RootNavigator { get }

    func navigate(to route: RootNavigator.Route) throws
}

extension GlobalNavigator {
    public func navigate(to route: RootNavigator.Route) throws {
        let source = self.rootNavigator.source
         try self.rootNavigator.navigate(from: source, to: route)
    }
}

extension GlobalNavigator {
    public var anyRootNavigator: AnyNavigator {
        return self.rootNavigator
    }
}
