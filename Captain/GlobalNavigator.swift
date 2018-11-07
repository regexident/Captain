// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
