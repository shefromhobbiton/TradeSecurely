//
//  TableViewDisputeCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 21/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class TableViewDisputeCell: UITableViewCell {
    @IBOutlet weak var lblDisputeID: UILabel!
    @IBOutlet weak var lblDisputeName: UILabel!
    @IBOutlet weak var lblDisputeStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
