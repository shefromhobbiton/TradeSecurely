//
//  TableViewPostJobsCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 04/02/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class TableViewPostJobsCell: UITableViewCell {

    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
