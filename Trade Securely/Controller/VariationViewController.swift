//
//  VariationViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 02/12/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class VariationViewController: UIViewController {
    
    let utils = Utils()
    let dbController = DBController()
    
    @IBOutlet weak var txtFldVariationID: UITextField!
    @IBOutlet weak var txtFldVariationStatus: UITextField!
    @IBOutlet weak var txtFldJobName: UITextField!
    @IBOutlet weak var txtFldNatureOfVariation: UITextField!
    @IBOutlet weak var txtFldVariationDescription: UITextView!
    @IBOutlet weak var txtFldCostOfVariation: UITextField!
    @IBOutlet weak var btnSubmitVariation: UIButton!
    @IBOutlet weak var btnRejectVariation: UIButton!
    
    var tempCost: Int = 0  //temporary storage fro variation cost
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpNavigationStyles()
        self.initilizeScreen()
    }
    
    @IBAction func btnSubmitVariation(_ sender: Any) {
        
        let lblA = btnSubmitVariation.titleLabel?.text
        let lblB = "Submit Variation"
        let isSubmit = (lblA == lblB)

        if  isSubmit {
            self.submitVariationEvent()
        } else {
            //approve variation
            approveVariation()
        }
    }
    
    @IBAction func txtFldVariationCostEditingDidEnd(_ sender: UITextField) {
        
        //get current value for database storage
        tempCost = Int(sender.text!) ?? 0
        
        //set thousands separator on amount
        if txtFldCostOfVariation.text?.count ?? 0 > 3 {
            txtFldCostOfVariation.text = utils.formatNumber(numValue: Int(txtFldCostOfVariation.text!)!)
        }
    }
    
    @IBAction func btnRejectVariation(_ sender: Any) {
        //reject variation
        self.rejectVariation()
    }
    
    //********************************* USER DEFINED FUNCTIONS ********************************//
    @objc func saveVariation() {
        if getDataFromTextField() {
            if globals.isEdit {
                //update table
                setSQLQuery(whichQuery: 1)
            } else {
                //save button is tapped
                saveDataToTable()
            }
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please fill up all the required information")
            present(alert, animated: true)
        }
    }
    
    //submit variation
    private func submitVariationEvent() {
        //check if isEditing
        if globals.isEdit {
            //update dispute status to Pending
            self.setSQLQuery(whichQuery: 2)
        } else {
            //save new data to table
            if getDataFromTextField() {
                
                //set status to 2 - "Pending"
                _tblVariations["variationStatus"] = 2  //"Pending"
                
                //save dispute
                self.saveVariation()
            }
        }
    }
    
    //approve variation routine
    private func approveVariation() {
        //set status to 4 - "Approved"
        self.setSQLQuery(whichQuery: 3)
    }
    
    //reject variation
    private func rejectVariation() {
        //set status to 4 - "Rejected"
        self.setSQLQuery(whichQuery: 4)
    }
    
    //set query when updating data on table
    private func setSQLQuery(whichQuery: Int){
        //check values
        // 1 - save button
        // 2 - submit variation button
        // 3 - approve variation
        // 4 - reject variation
        
        // 1 - "Draft", 2 - "Pending", 3 - "Active", 4 - "Approved", 5 - "Rejected"
        var sqlStr: String = ""
        var tempStatus = 0
        
        if whichQuery == 1 {  //save button is pressed
            sqlStr = "UPDATE tblVariation SET natureOfVariation = '"
            sqlStr += _tblVariations["natureOfVariation"] as! String + "', description = '"
            sqlStr += _tblVariations["description"] as! String + "', cost = \(_tblVariations["cost"]!) "
            sqlStr += "WHERE id = \(_tblVariations["id"]!)"
        } else {  // submit variation is selected
            if whichQuery == 2 {
                tempStatus = 2 //Pending
            } else if whichQuery == 3 {
                tempStatus = 4  //Approved
            } else if whichQuery == 4 {
                tempStatus = 5 //reject variation
            }
            
            sqlStr = "UPDATE tblVariation SET variationStatus = \(tempStatus) "
            sqlStr += "WHERE id = \(_tblVariations["id"]!)"
        }
        
        if whichQuery == 3 {
            //show signature screen
            showNextScreen(screenName: "VariationAddSignatureViewController")
        } else {
            //send query and update table
            self.updateDataOnTable(sqlStr: sqlStr, status: tempStatus)
        }
    }
    
    
    //check if complete data
    private func getDataFromTextField()->Bool {
        //copy data frm textfields
        if txtFldNatureOfVariation.text!.count > 0 {
            _tblVariations["natureOfVariation"] = txtFldNatureOfVariation.text
        } else  {
            return false
        }
        
        if txtFldVariationDescription.text!.count > 0 {
            _tblVariations["description"] = txtFldVariationDescription.text
        } else {
            return false
        }
        
        if txtFldCostOfVariation.text!.count > 0 {
            _tblVariations["cost"] = tempCost //Int(txtFldCostOfVariation.text!)
        } else {
            return false
        }
       
        _tblVariations["jobID"] = globals.currentJobID
        
        return true
    }
    
    //set data on textfields
    private func setDataOnTextFields() {
        
        //variation id
        txtFldVariationID.text = String(_tblVariations["id"] as! Int)
        
        //status
        txtFldVariationStatus.text = dbController.getVariationStatus(status: _tblVariations["variationStatus"] as! Int)
        
        //job name
        txtFldJobName.text = globals.currentJobName
        
        //nature
        txtFldNatureOfVariation.text = (_tblVariations["natureOfVariation"] as! String)
        
        //desc
        txtFldVariationDescription.text = (_tblVariations["description"] as! String)
        
        //cost
        txtFldCostOfVariation.text = String(_tblVariations["cost"] as! Int)
        //set thousands separator on amount
        if txtFldCostOfVariation.text?.count ?? 0 > 3 {
            txtFldCostOfVariation.text = utils.formatNumber(numValue: Int(txtFldCostOfVariation.text!)!)
        }
        
        
    }
    
    //save user inputs to database tables
    private func saveDataToTable() {
        //open db or create when not yet available
        if dbController.openDatabaseFile() == true {
            if dbController.saveVariationDataToDB() == true {
                //self.showNextScreen(screenName: "DisputeListViewController")
                _ = navigationController?.popViewController(animated: true) //return to previous screen
            }
        } else {
            print("cannot connect to database")
        }
    }
    
    //update table
    private func updateDataOnTable(sqlStr: String, status: Int) {
        if dbController.openDatabaseFile() == true {
            if dbController.updateTable(queryStr: sqlStr) {
                //return to dispute list
                //self.showNextScreen(screenName: "DisputeListViewController")
                
                if status == 5 {  //show Helpful Hints
                    showNextScreen(screenName: "HelpfulHintsViewController")
                } else {
                    _ = navigationController?.popViewController(animated: true) //return to previous screen
                }
            }
        } else {
            print("cannot connect to database")
        }
    }

    //get last variationID
    private func getLastVariationID()->Int {
        
        var tempID = 0
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                tempID = dbController.getLastID(queryStr: "SELECT MAX(id) FROM tblVariation") + 1
                return tempID
            }
        }
        return 0
    }
    
    //disable editing
    private func disableEditing() {
        txtFldNatureOfVariation.isEnabled = false
        txtFldVariationDescription.isEditable = false
        txtFldCostOfVariation.isEnabled = false
    }
    
    //initialize screen
    private func initilizeScreen() {
        
        if globals.isEdit {
            
            //set textfield values
            setDataOnTextFields()
            
            let tempStatus = _tblVariations["variationStatus"] as! Int
            if tempStatus == 2 { //Pending
                //rename button
                btnSubmitVariation.setTitle("Approve Variation", for: .normal)
                
                //show reject variation
                btnRejectVariation.isHidden = false
                
                //hide Save Button
                self.navigationItem.rightBarButtonItem = nil
                
                //diable editing
                disableEditing()
            } else if tempStatus == 4 || tempStatus == 5 {  //approve||rejected
                //diable editing
                disableEditing()
                
                //hide all buttons
                btnRejectVariation.isHidden = true
                btnSubmitVariation.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
            
        } else {
            //create new record
            //set variationID for display
            txtFldVariationID.text = String(getLastVariationID())
            
            //set job name
            txtFldJobName.text = globals.currentJobName
            
            //set variationStatus
            txtFldVariationStatus.text = "Draft"
            //set status to 1 - "Draft"
            _tblVariations["variationStatus"] = 1  //"Draft"
        }
    }
    
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Variation"
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveVariation))
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
