// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol NavigatorHost: class {
    associatedtype Navigator: Captain.Navigator

    var navigator: Navigator? { get set }
}

extension NavigatorHost where Navigator.Source == Self {
    public var navigator: Navigator? {
        set {
            self.anyNavigator = navigator
        }
        get {
            let navigator: Navigator?
            if let anyNavigator = self.anyNavigator {
                navigator = anyNavigator as? Navigator
            } else {
                navigator = Navigator(source: self)
                self.anyNavigator = navigator
            }
            return navigator
        }
    }
}
