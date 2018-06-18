//
//  AppDelegate.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/25/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootTabBarController: RootTabBarController {
        guard let window = self.window else {
            fatalError("Expected `self.window`, found `nil`.")
        }
        guard let controller = window.rootViewController as? RootTabBarController else {
            fatalError("Expected `window.rootViewController`, found `nil`.")
        }
        return controller
    }

    var rootTabBarNavigator: RootTabBarNavigator {
        let source = self.rootTabBarController
        return RootTabBarNavigator.attached(to: source)
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = self.window!.rootViewController as! UITabBarController

        for viewController in tabBarController.viewControllers ?? [] {
            guard let navigationViewController = viewController as? UINavigationController else {
                continue
            }
            guard let viewController = navigationViewController.viewControllers.first else {
                continue
            }
            let managedObjectContext = self.persistentContainer.viewContext
            self.rootTabBarController.managedObjectContext = managedObjectContext
            if let continentsTableViewController = viewController as? ContinentsTableViewController {
                continentsTableViewController.managedObjectContext = managedObjectContext
            } else if let oceansTableViewController = viewController as? OceansTableViewController {
                oceansTableViewController.managedObjectContext = managedObjectContext
            } else {
                fatalError("Unknown controller: \(type(of: viewController))")
            }
        }

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            ModelPopulator().populate(managedObjectContext: container.viewContext)
        })
        return container
    }()
}
