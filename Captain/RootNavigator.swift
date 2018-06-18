//
//  RootNavigator.swift
//  Captain
//
//  Created by Vincent Esche on 6/6/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

public protocol RootNavigator: Navigator {
    var source: Source { get }
}
