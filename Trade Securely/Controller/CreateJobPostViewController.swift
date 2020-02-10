//
//  CreateJobPostViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 06/02/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class CreateJobPostViewController: UIViewController {

    @IBOutlet weak var txtFldContactName: UITextField!
    @IBOutlet weak var txtFldJobName: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldDStartDate: UITextField!
    @IBOutlet weak var txtViewJobDesc: UITextView!
    
    @IBOutlet weak var btnCreateJobPost: UIButton!
    
    let utils = Utils()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        //set up initial view
        initializeScreen()
    }
    
    
    @IBAction func txtFldDStartDateEvent(_ sender: Any) {
        
    }
    
    
    @IBAction func btnCreateJobPostEvent(_ sender: Any) {
        
        //save job post
        
        
        //return to previous screen
        _ = navigationController?.popViewController(animated: true)
    }
    
    /*************  USER DEFINED FUNCTIONS ****************/
    
    @objc func doneButton() {
        
        if let datePicker = self.txtFldDStartDate.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            self.txtFldDStartDate.text = dateformatter.string(from: datePicker.date)
            
        }
        self.txtFldDStartDate.resignFirstResponder()
    }
    
    private func initializeScreen() {
        
        //set date picker as keyboard
        txtFldDStartDate.setInputViewDatePicker(target: self, selector: #selector(doneButton))
        
    }
    
    func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Create Job Post"
        self.navigationItem.backBarButtonItem?.title = "Back"
    }

}
