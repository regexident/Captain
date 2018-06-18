//
//  CountryViewController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/25/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

protocol CountryReceiver {
    func set(country: Country)
}

class CountryViewController: UIViewController {
    private(set) public var country: Country? {
        didSet {
            guard let country = self.country else {
                return
            }
            self.update(country: country)
        }
    }

    @IBOutlet var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // If shown modally, make sure the user can actually close the controller:
        if self.presentingViewController != nil {
            self.addCloseButton()
        }

        if let country = self.country {
            self.update(country: country)
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
            action: #selector(CountryViewController.close(_:))
        )
    }

    private func update(country: Country) {
        self.title = country.name

        if let label = self.label {
            label.text = country.name
        }
    }
}

extension CountryViewController: CountryReceiver {
    func set(country: Country) {
        self.country = country
    }
}
