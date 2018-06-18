//
//  Sea+Extensions.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/4/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import Foundation
import CoreData

extension Sea {
    static func all(context: NSManagedObjectContext) -> [Sea] {
        let fetchRequest: NSFetchRequest<Sea> = Sea.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            fatalError("Error: \(error)")
        }
    }

    static func instance(id: Int64, context: NSManagedObjectContext) -> Sea? {
        let fetchRequest: NSFetchRequest<Sea> = Sea.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
