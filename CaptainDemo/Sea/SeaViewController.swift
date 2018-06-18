//
//  SeaViewController.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 5/25/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

protocol SeaReceiver {
    func set(sea: Sea)
}

class SeaViewController: UIViewController {
    private(set) public var sea: Sea? {
        didSet {
            guard let sea = self.sea else {
                return
            }
            self.update(sea: sea)
        }
    }

    @IBOutlet var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // If shown modally, make sure the user can actually close the controller:
        if self.presentingViewController != nil {
            self.addCloseButton()
        }

        if let sea = self.sea {
            self.update(sea: sea)
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
            action: #selector(SeaViewController.close(_:))
        )
    }

    private func update(sea: Sea) {
        self.title = sea.name

        if let label = self.label {
            label.text = sea.name
        }
    }
}

extension SeaViewController: SeaReceiver {
    func set(sea: Sea) {
        self.sea = sea
    }
}
