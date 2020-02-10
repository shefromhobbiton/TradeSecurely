//
//  TableViewOpenJobsCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 01/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class TableViewOpenJobsCell: UITableViewCell {

    @IBOutlet weak var lblProjName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblJobID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
