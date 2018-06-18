//
//  NavigatorHost.swift
//  Captain
//
//  Created by Vincent Esche on 6/15/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

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
