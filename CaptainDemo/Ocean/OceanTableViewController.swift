//
//  OceanTableViewController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit
import CoreData

import Captain

protocol OceanTableViewControllerDelegate: class {
    func controller(
        _ controller: OceanTableViewController,
        didSelectSea sea: Sea
    )
    func controller(
        _ controller: OceanTableViewController,
        didSelectContinent continent: Continent
    )
}

protocol OceanReceiver {
    func set(managedObjectContext: NSManagedObjectContext)
    func set(ocean: Ocean)
}

protocol SeasProvider {
    func seaWith(id: Int64) -> Sea?
}

class OceanTableViewController: UITableViewController {
    private enum Section: Int {
        case continents
        case seas

        static let allValues: [Section] = [.continents, .seas]
    }

    private var ocean: Ocean? {
        didSet {
            guard let ocean = self.ocean else {
                return
            }

            self.title = ocean.name

            self.tableView.separatorStyle = .none
            self.tableView.rowHeight = 50.0

            self.tableView.register(
                TableViewHeaderFooterView.self,
                forHeaderFooterViewReuseIdentifier: "headerFooterView"
            )

            let seasFetchRequest = self.seasFetchedResultsController.fetchRequest
            seasFetchRequest.predicate = NSPredicate(format: "ocean = %@", ocean)

            let continentsFetchRequest = self.continentsFetchedResultsController.fetchRequest
            continentsFetchRequest.predicate = NSPredicate(format: "oceans CONTAINS %@", ocean)

            NSFetchedResultsController<Sea>.deleteCache(
                withName: self.seasFetchedResultsController.cacheName
            )

            NSFetchedResultsController<Continent>.deleteCache(
                withName: self.continentsFetchedResultsController.cacheName
            )

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private var managedObjectContext: NSManagedObjectContext? = nil

    private var _seasFetchedResultsController: NSFetchedResultsController<Sea>? = nil
    private var _continentsFetchedResultsController: NSFetchedResultsController<Continent>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
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
            action: #selector(OceanTableViewController.close(_:))
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
        //        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allValues[section] {
        case .continents:
            return self.continentsFetchedResultsController.sections![0].numberOfObjects
        case .seas:
            return self.seasFetchedResultsController.sections![0].numberOfObjects
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let ocean = self.ocean?.name else {
            return nil
        }
        switch Section.allValues[section] {
        case .continents:
            return "Continents bordering \(ocean)"
        case .seas:
            return "Seas of \(ocean)"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch Section.allValues[indexPath.section] {
        case .continents:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let continent = self.continentsFetchedResultsController.object(at: indexPath)
            self.configureCell(cell, withContinent: continent)
        case .seas:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let sea = self.seasFetchedResultsController.object(at: indexPath)
            self.configureCell(cell, withSea: sea)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.allValues[indexPath.section] {
        case .continents:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let continent = self.continentsFetchedResultsController.object(at: indexPath)
            self.didSelect(continent: continent)
        case .seas:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let sea = self.seasFetchedResultsController.object(at: indexPath)
            self.didSelect(sea: sea)
        }
    }

    func didSelect(sea: Sea) {
                guard let navigator = self.navigator else {
            fatalError("Expected `self.navigator`, found `nil`.")
        }

        navigator.controller(self, didSelectSea: sea)
    }

    func didSelect(continent: Continent) {
                guard let navigator = self.navigator else {
            fatalError("Expected `self.navigator`, found `nil`.")
        }

        navigator.controller(self, didSelectContinent: continent)
    }

    func configureCell(_ cell: UITableViewCell, withSea sea: Sea) {
        cell.textLabel!.text = sea.name
        cell.imageView?.image = UIImage(named: "Green")
    }

    func configureCell(_ cell: UITableViewCell, withContinent continent: Continent) {
        cell.textLabel!.text = continent.name
        cell.imageView?.image = UIImage(named: "Red")
    }
}

extension OceanTableViewController: NSFetchedResultsControllerDelegate {
    // MARK: - Fetched results controller

    var seasFetchedResultsController: NSFetchedResultsController<Sea> {
        if self._seasFetchedResultsController != nil {
            return self._seasFetchedResultsController!
        }

        guard let ocean = self.ocean else {
            fatalError("Expected `self.ocean`, found `nil`.")
        }

        let fetchRequest: NSFetchRequest<Sea> = Sea.fetchRequest()

        // Restrict to seas of given ocean.
        fetchRequest.predicate = NSPredicate(format: "ocean = %@", ocean)

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: "Sea"
        )
        fetchedResultsController.delegate = self
        self._seasFetchedResultsController = fetchedResultsController

        do {
            try self._seasFetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return self._seasFetchedResultsController!
    }

    var continentsFetchedResultsController: NSFetchedResultsController<Continent> {
        if self._continentsFetchedResultsController != nil {
            return self._continentsFetchedResultsController!
        }

        guard let ocean = self.ocean else {
            fatalError("Expected `self.ocean`, found `nil`.")
        }

        let fetchRequest: NSFetchRequest<Continent> = Continent.fetchRequest()

        // Restrict to seas of given ocean.
        fetchRequest.predicate = NSPredicate(format: "oceans CONTAINS %@", ocean)

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: "Ocean"
        )
        fetchedResultsController.delegate = self
        self._continentsFetchedResultsController = fetchedResultsController

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
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
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
                withSea: anObject as! Sea
            )
        case .move:
            self.configureCell(
                self.tableView.cellForRow(at: indexPath!)!,
                withSea: anObject as! Sea
            )
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension OceanTableViewController: NavigatorHost {
    typealias Navigator = OceanTableViewNavigator
}

extension OceanTableViewController: OceanReceiver {
    func set(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func set(ocean: Ocean) {
        self.ocean = ocean
    }
}

extension OceanTableViewController: SeasProvider {
    func seaWith(id: Int64) -> Sea? {
        guard let context = self.managedObjectContext else {
            fatalError("Expected `self.managedObjectContext`, found `nil`.")
        }
        let fetchRequest: NSFetchRequest<Sea> = Sea.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
