// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

enum AssociatedObject {
    static let key = ObjectIdentifier(AssociatedObject.self)
}

public protocol AnyNavigatorHost: class {
    var anyNavigator: AnyNavigator? { get set }
}

extension AnyNavigatorHost {
    public var anyNavigator: AnyNavigator? {
        set {
            var key = AssociatedObject.key
            let value = newValue as Any
            objc_setAssociatedObject(value, &key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var key = AssociatedObject.key
            guard let navigator = objc_getAssociatedObject(self, &key) as? AnyNavigator else {
                return nil
            }
            return navigator
        }
    }
}

extension UIViewController: AnyNavigatorHost {

}
