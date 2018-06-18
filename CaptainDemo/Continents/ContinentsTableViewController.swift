//
//  ContinentsTableViewController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit
import CoreData

import Captain

protocol ContinentsDelegate: class {
    func controller(
        _ controller: ContinentsTableViewController,
        didSelectContinent continent: Continent
    )
}

protocol ContinentsProvider {
    func continentWith(id: Int64) -> Continent?
}

class ContinentsTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext? = nil

    private var _continentsFetchedResultsController: NSFetchedResultsController<Continent>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Continents"

        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 50.0

        self.tableView.register(
            TableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: "headerFooterView"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // If shown modally, make sure the user can actually close the controller:
        if self.presentingViewController != nil {
            self.addCloseButton()
        }
    }

    @objc private func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    private func addCloseButton() {
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(ContinentsTableViewController.close(_:))
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.continentsFetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.continentsFetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let continent = self.continentsFetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withContinent: continent)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let continent = self.continentsFetchedResultsController.object(at: indexPath)

                guard let navigator = self.navigator else {
            fatalError("Expected `self.navigator`, found `nil`.")
        }
        
        navigator.controller(self, didSelectContinent: continent)
    }

    func configureCell(_ cell: UITableViewCell, withContinent continent: Continent) {
        cell.textLabel!.text = continent.name
        cell.imageView?.image = UIImage(named: "Red")
    }
}

extension ContinentsTableViewController: NSFetchedResultsControllerDelegate {
    // MARK: - Fetched results controller

    var continentsFetchedResultsController: NSFetchedResultsController<Continent> {
        if self._continentsFetchedResultsController != nil {
            return self._continentsFetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<Continent> = Continent.fetchRequest()

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let continentsFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: "Continent"
        )
        continentsFetchedResultsController.delegate = self
        self._continentsFetchedResultsController = continentsFetchedResultsController

        do {
            try self._continentsFetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return self._continentsFetchedResultsController!
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(
                self.tableView.cellForRow(at: indexPath!)!,
                withContinent: anObject as! Continent
            )
        case .move:
            self.configureCell(
                self.tableView.cellForRow(at: indexPath!)!,
                withContinent: anObject as! Continent
            )
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension ContinentsTableViewController: NavigatorHost {
    typealias Navigator = ContinentsTableViewNavigator
}

extension ContinentsTableViewController: ContinentsProvider {
    func continentWith(id: Int64) -> Continent? {
        guard let context = self.managedObjectContext else {
            fatalError("Expected `self.managedObjectContext`, found `nil`.")
        }
        let fetchRequest: NSFetchRequest<Continent> = Continent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
