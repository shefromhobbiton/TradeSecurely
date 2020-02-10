//
//  TableViewInputCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 27/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class TableViewInputCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtFieldDetails: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        txtFieldDetails.delegate = self
        addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /******************* USER DEFINED FUNCTIONS **********************/
    //add done button
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = UIColor.orange
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtFieldDetails.inputAccessoryView = doneToolbar
    }
    
    //done button action
    @objc func doneButtonAction(){
        txtFieldDetails.resignFirstResponder()
    }
}
