//
//  TableViewCell.swift
//  CaptainDemo
//
//  Created by Vincent Esche on 6/7/18.
//  Copyright © 2018 Vincent Esche. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
