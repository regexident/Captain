//
//  ContinentTableViewController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/28/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit
import CoreData

import Captain

protocol ContinentTableViewControllerDelegate: class {
    func controller(
        _ controller: ContinentTableViewController,
        didSelectCountry country: Country
    )
    func controller(
        _ controller: ContinentTableViewController,
        didSelectOcean ocean: Ocean
    )
}

protocol ContinentReceiver {
    func set(managedObjectContext: NSManagedObjectContext)
    func set(continent: Continent)
}

protocol CountriesProvider {
    func countryWith(id: Int64) -> Country?
}

class ContinentTableViewController: UITableViewController {
    private enum Section: Int {
        case oceans
        case countries

        static let allValues: [Section] = [.oceans, .countries]
    }

    private var continent: Continent? {
        didSet {
            guard let continent = self.continent else {
                return
            }

            self.title = continent.name

            self.tableView.separatorStyle = .none
            self.tableView.rowHeight = 50.0

            self.tableView.register(
                TableViewHeaderFooterView.self,
                forHeaderFooterViewReuseIdentifier: "headerFooterView"
            )

            let countriesFetchRequest = self.countriesFetchedResultsController.fetchRequest
            countriesFetchRequest.predicate = NSPredicate(format: "continent = %@", continent)

            let oceansFetchRequest = self.oceansFetchedResultsController.fetchRequest
            oceansFetchRequest.predicate = NSPredicate(format: "continents CONTAINS %@", continent)

            NSFetchedResultsController<Country>.deleteCache(
                withName: self.countriesFetchedResultsController.cacheName
            )

            NSFetchedResultsController<Ocean>.deleteCache(
                withName: self.oceansFetchedResultsController.cacheName
            )

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private var managedObjectContext: NSManagedObjectContext? = nil

    private var _countriesFetchedResultsController: NSFetchedResultsController<Country>? = nil
    private var _oceansFetchedResultsController: NSFetchedResultsController<Ocean>? = nil

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
            action: #selector(ContinentTableViewController.close(_:))
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
//        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allValues[section] {
        case .oceans:
            return self.oceansFetchedResultsController.sections![0].numberOfObjects
        case .countries:
            return self.countriesFetchedResultsController.sections![0].numberOfObjects
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let continent = self.continent?.name else {
            return nil
        }
        switch Section.allValues[section] {
        case .oceans:
            return "Oceans bordering \(continent)"
        case .countries:
            return "Countries of \(continent)"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch Section.allValues[indexPath.section] {
        case .oceans:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let ocean = self.oceansFetchedResultsController.object(at: indexPath)
            self.configureCell(cell, withOcean: ocean)
        case .countries:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let country = self.countriesFetchedResultsController.object(at: indexPath)
            self.configureCell(cell, withCountry: country)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.allValues[indexPath.section] {
        case .oceans:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let ocean = self.oceansFetchedResultsController.object(at: indexPath)
            self.didSelect(ocean: ocean)
        case .countries:
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let country = self.countriesFetchedResultsController.object(at: indexPath)
            self.didSelect(country: country)
        }
    }

    func didSelect(country: Country) {
                guard let navigator = self.navigator else {
            fatalError("Expected `self.navigator`, found `nil`.")
        }

        navigator.controller(self, didSelectCountry: country)
    }

    func didSelect(ocean: Ocean) {
                guard let navigator = self.navigator else {
            fatalError("Expected `self.navigator`, found `nil`.")
        }

        navigator.controller(self, didSelectOcean: ocean)
    }

    func configureCell(_ cell: UITableViewCell, withCountry country: Country) {
        cell.textLabel!.text = country.name
        cell.imageView?.image = UIImage(named: "Orange")
    }

    func configureCell(_ cell: UITableViewCell, withOcean ocean: Ocean) {
        cell.textLabel!.text = ocean.name
        cell.imageView?.image = UIImage(named: "Yellow")
    }
}

extension ContinentTableViewController: NSFetchedResultsControllerDelegate {
    // MARK: - Fetched results controller

    var countriesFetchedResultsController: NSFetchedResultsController<Country> {
        if self._countriesFetchedResultsController != nil {
            return self._countriesFetchedResultsController!
        }

        guard let continent = self.continent else {
            fatalError("Expected `self.continent`, found `nil`.")
        }

        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()

        // Restrict to countries of given continent.
        fetchRequest.predicate = NSPredicate(format: "continent = %@", continent)

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
            cacheName: "Country"
        )
        fetchedResultsController.delegate = self
        self._countriesFetchedResultsController = fetchedResultsController

        do {
            try self._countriesFetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return self._countriesFetchedResultsController!
    }

    var oceansFetchedResultsController: NSFetchedResultsController<Ocean> {
        if self._oceansFetchedResultsController != nil {
            return self._oceansFetchedResultsController!
        }

        guard let continent = self.continent else {
            fatalError("Expected `self.continent`, found `nil`.")
        }

        let fetchRequest: NSFetchRequest<Ocean> = Ocean.fetchRequest()

        // Restrict to countries of given continent.
        fetchRequest.predicate = NSPredicate(format: "continents CONTAINS %@", continent)

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
        self._oceansFetchedResultsController = fetchedResultsController

        do {
            try self._oceansFetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return self._oceansFetchedResultsController!
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
                withCountry: anObject as! Country
            )
        case .move:
            self.configureCell(
                self.tableView.cellForRow(at: indexPath!)!,
                withCountry: anObject as! Country
            )
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension ContinentTableViewController: NavigatorHost {
    typealias Navigator = ContinentTableViewNavigator // ContinentTableViewControllerDelegate
}

extension ContinentTableViewController: ContinentReceiver {
    func set(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func set(continent: Continent) {
        self.continent = continent
    }
}

extension ContinentTableViewController: CountriesProvider {
    func countryWith(id: Int64) -> Country? {
        guard let context = self.managedObjectContext else {
            fatalError("Expected `self.managedObjectContext`, found `nil`.")
        }
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch let error {
            fatalError("Error: \(error)")
        }
    }
}
