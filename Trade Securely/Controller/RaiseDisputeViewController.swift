//
//  RaiseDisputeViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 22/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class RaiseDisputeViewController: UIViewController {

    let utils = Utils()
    let dbController = DBController()
    
    @IBOutlet weak var txtFldDIsputeID: UITextField!
    @IBOutlet weak var txtFldDisputeStatus: UITextField!
    @IBOutlet weak var txtFldJobName: UITextField!
    @IBOutlet weak var txtFldNatureOfDispute: UITextField!
    @IBOutlet weak var txtFldDispute: UITextView!
    @IBOutlet weak var txtFldProposedResolution: UITextView!
    @IBOutlet weak var btnSubmitDispute: UIButton!
    
    var isSubmitDispute = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        //set up screen
        initializeScreen()
    }
    
    @IBAction func btnSubmitDispute(_ sender: Any) {

        //set switch
        isSubmitDispute = true
        
        //update dispute status on current placeholder
        globals.currentDisputeStatus = 2
        
        //update dispute status
        submitDisputeEvent()
    }
    
    //************************* USER DEFINED FUNCTIONS **********************************//
    @objc func saveDispute() {
        if getDataFromTextField() {
            //save data to table
            if globals.isEdit {
                isSubmitDispute = false  //is dispute update
                self.updateDataOnTable() //update current record
            } else {  //add new record
                self.saveDataToTable()
            }
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please fill up all the required information")
            present(alert, animated: true)
        }
    }
    
    private func submitDisputeEvent() {
        
        //check if isEditing
        if globals.isEdit {
            //update dispute status to Pending
            self.updateDataOnTable()
        } else {
            self.saveDispute()
        }
        
        if globals.currentDisputeStatus == 2 {
            print("show dispute payment screen")
            //show Dispute Payment Screen
            showNextScreen(screenName: "DisputePaymentViewController")
        } else {
            
            print("return to dispute list")
            let vc = UIViewController(nibName: "DisputeListViewController", bundle: .main)
            _ = navigationController?.popToViewController(vc, animated: true) //return to previous screen
            
            //_ = navigationController?.popViewController(animated: true) //return to previous screen
        }
    }
    
    //save user inputs to database tables
    private func saveDataToTable() {
        //open db or create when not yet available
        
        if dbController.openDatabaseFile() == true {
            if dbController.saveDisputeDataToDB() == true {
                //self.showNextScreen(screenName: "DisputeListViewController")
                //_ = navigationController?.popViewController(animated: true) //return to previous screen
            }
            
        } else {
            print("cannot connect to database")
        }
    }
    
    //update data to table
    private func updateDataOnTable(){
        var status = 0
        
        // 1 - "Draft", 2 - "Pending", 3 - "Active", 4 - "Completed"
        //let tempID: String = _tblDisputes["id"] as! String
        var sqlStr: String = ""
        
        //if on edit
        if isSubmitDispute {
            
            
            if globals.currentDisputeStatus == 1 {
                status = 2 //set to "Pending"
                globals.currentDisputeStatus = 2 //update globals
            }
            else {
                status = 4 //set to "Completed"
                globals.currentDisputeStatus = 4 //update globals
            }
            
            sqlStr = "UPDATE tblDispute SET disputeStatus = \(status) "
            sqlStr += "WHERE id = \(_tblDisputes["id"]!)"
            
        } else {
            sqlStr = "UPDATE tblDispute SET natureOfDispute = '"
            sqlStr += _tblDisputes["natureOfDispute"] as! String + "', description = '"
            sqlStr += _tblDisputes["description"] as! String + "', proposedResolution = '"
            sqlStr += _tblDisputes["proposedResolution"] as! String
            sqlStr += "' WHERE id = \(_tblDisputes["id"]!)"
        }
       
        //update table
        //open db or create when not yet available
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.updateTable(queryStr: sqlStr) {
                //return to dispute list
                //self.showNextScreen(screenName: "DisputeListViewController")
                //_ = navigationController?.popViewController(animated: true) //return to previous screen
            }
        } else {
            print("cannot connect to database")
        }
    }
    
    //check if complete data
    private func getDataFromTextField()->Bool {
        
        //copy data frm textfields
        if txtFldNatureOfDispute.text!.count > 0 {
            _tblDisputes["natureOfDispute"] = txtFldNatureOfDispute.text
        } else  {
            return false
        }
        
        if txtFldDispute.text!.count > 0 {
            _tblDisputes["description"] = txtFldDispute.text
        } else {
            return false
        }
        
        if txtFldProposedResolution.text!.count > 0 {
            _tblDisputes["proposedResolution"] = txtFldProposedResolution.text
        } else {
            return false
        }
        
        _tblDisputes["jobID"] = globals.currentJobID
        _tblDisputes["disputeStatus"] = globals.currentDisputeStatus //txtFldDisputeStatus.text
        
        return true
    }
    
    //fetch data from table
    private func fetchData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblDispute WHERE jobID = '" + String(globals.currentJobID) + "'"
                dbController.readFromTableDisputes(queryStr: sqlString)
            }
        }
    }
    
    //disbable editing
    private func disableEditing() {
        txtFldNatureOfDispute.isEnabled = false
        txtFldDispute.isEditable = false
        txtFldProposedResolution.isEditable = false
    }
    
    //initializeScreen()
    private func initializeScreen() {
        var tempDisputeID = 0
        if globals.currentDisputeStatus == 0 {
            if dbController.openDatabaseFile() == true {
                if dbController.createTable() == true {
                    tempDisputeID = dbController.getLastDisputeID() + 1
                    globals.currentDisputeStatus = 1
                }
            }
            
        } else {
            //setTextOnTextFields
            tempDisputeID = _tblDisputes["id"] as! Int
            txtFldNatureOfDispute.text = (_tblDisputes["natureOfDispute"] as! String)
            txtFldDispute.text = (_tblDisputes["description"] as! String)
            txtFldProposedResolution.text =  (_tblDisputes["proposedResolution"] as! String)
            
            // 1 - "Draft", 2 - "Pending", 3 - "Active", 4 - "Resolved"
            if globals.currentDisputeStatus == 2 { //Pending
                //hide save button
                self.navigationItem.rightBarButtonItem = nil
                
                //rename button
                btnSubmitDispute.setTitle("Resolution Accepted", for: .normal)
                
                //disable editing
                disableEditing()
            } else if globals.currentDisputeStatus == 4 { //Resolved
                
                //disable editing
                disableEditing()
                
                //hide buttons
                btnSubmitDispute.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
        //set dispute id
        txtFldDIsputeID.text = String(tempDisputeID)
        
        //set current dispute status
        txtFldDisputeStatus.text = dbController.getDisputeStatus(status: globals.currentDisputeStatus)
        txtFldJobName.text = globals.currentJobName
    }
    
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Raise Dispute"
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDispute))
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
