//
//  RootTabBarController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/6/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit
import CoreData

import Captain

class RootTabBarController: UITabBarController {
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RootTabBarController: NavigatorHost {
    typealias Navigator = RootTabBarNavigator
}
