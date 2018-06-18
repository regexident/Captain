//
//  AnyNavigatorHost.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

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
