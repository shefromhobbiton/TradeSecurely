//
//  TableViewAddPaymentCell.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 23/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class TableViewAddPaymentCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtfldPayment: UITextField!
    @IBOutlet weak var lblPaymentNo: UILabel!
    @IBOutlet weak var btnDeletePayment: UIButton!
    
    let utils = Utils()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func txtFldPayment(_ sender: UITextField) {
        
    }
    
    @IBAction func btnDeleteEvent(_ sender: Any) {
        
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
        
        txtfldPayment.inputAccessoryView = doneToolbar
    }
    
    //done button action
    @objc func doneButtonAction(){
        txtfldPayment.resignFirstResponder()
    }
}
