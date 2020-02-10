//
//  TableViewJobsCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 22/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class TableViewJobsCell: UITableViewCell {
    
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
