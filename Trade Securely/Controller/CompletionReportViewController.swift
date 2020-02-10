//
//  CompletionReportViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 11/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CompletionReportViewController: UIViewController {
    @IBOutlet weak var txtFldJobID: UITextField!
    @IBOutlet weak var txtFldJobStatus: UITextField!
    @IBOutlet weak var txtFldPrjoectName: UITextField!
    @IBOutlet weak var txtFldJobName: UITextField!
    @IBOutlet weak var txtFldBuyerName: UITextField!
    @IBOutlet weak var txtFldStartDate: UITextField!
    @IBOutlet weak var txtFldCompletionDate: UITextField!
    @IBOutlet weak var txtViewCompletionDetails: UITextView!
    @IBOutlet weak var txtViewDeficiencies: UITextView!
    
    @IBOutlet weak var btnSubmitReport: UIButton!
    @IBOutlet weak var btnAcceptReport: UIButton!
    
    @IBOutlet weak var uiViewSubmitReport: UIView!
    @IBOutlet weak var uiVIewAcceptReport: UIView!
    
    let utils = Utils()
    var whichData = 0 //1-start date, 2-completion/end date
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //set up screen
        initializeScreen()
    }
    
    //txtfield events
    @IBAction func btnStartDate(_ sender: Any) {
        whichData = 1
    }
    @IBAction func btnCompletionDate(_ sender: Any) {
        whichData = 2
    }
    
    //button events
    @IBAction func btnAcceptReport(_ sender: Any) {
        btnAcceptReportRoutine()
    }
    
    @IBAction func btnSubmitReport(_ sender: Any) {
        btnSubmitReportRoutine()
    }
    
    
    //**************** USER DEFINED FUNCTIONS ****************//
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = globals.screenName
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //set up date input fields
    private func setUpDateInputTextFields() {
        //set date picker as keyboard
        txtFldStartDate.setInputViewDatePicker(target: self, selector: #selector(doneButton))
        txtFldCompletionDate.setInputViewDatePicker(target: self, selector: #selector(doneButton))
    }
    
    @objc func doneButton(){
        //start date
        if whichData == 1 {
            if let datePicker = self.txtFldStartDate.inputView as? UIDatePicker {
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .long
                self.txtFldStartDate.text = dateformatter.string(from: datePicker.date)
                
            }
            self.txtFldStartDate.resignFirstResponder()
        }
        
        //completion/end date
        if whichData == 2 {
            if let datePicker = self.txtFldCompletionDate.inputView as? UIDatePicker {
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .long
                
                self.txtFldCompletionDate.text = dateformatter.string(from: datePicker.date)
            }
            self.txtFldCompletionDate.resignFirstResponder()
        }
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    //set data on textfields
    private func setDataOnTextFields() {
        
        //job id
        txtFldJobID.text = String(globals.currentJobID)
        
        //status
        txtFldJobStatus.text = globals.currentJobStatus
    
        //project name
        txtFldPrjoectName.text = _tblCurrentJobData[0].projectName
        
        //job name
        txtFldJobName.text = _tblCurrentJobData[0].jobName
        
        //buyer's name
        txtFldBuyerName.text = _tblCurrentJobData[0].sellerName
        
        if globals.currentJobStatusID == 3 { //set completion report details
            
            //actual start date
            txtFldStartDate.text = _tblCurrentJobData[0].actualStartDate
            
            //actual completion date
            txtFldCompletionDate.text = _tblCurrentJobData[0].actualEndDate
            
            //completion details
            txtViewCompletionDetails.text = _tblCurrentJobData[0].completionDetails
            
            //deficiencies
            txtViewDeficiencies.text = _tblCurrentJobData[0].deficiencies
        }
    }
    
    //get data on textfields
    private func getDataFromTextFields() {
        //actual start date
        _tblJobs["actualStartDate"] = txtFldStartDate.text

        //actual completion date
        _tblJobs["actualEndDate"] = txtFldCompletionDate.text

        //completion details
        _tblJobs["completionDetails"] = txtViewCompletionDetails.text

        //deficiencies
        _tblJobs["deficiencies"] = txtViewDeficiencies.text
    }

    //submit report routine
    private func btnSubmitReportRoutine() {
        //get data from text fields
        getDataFromTextFields()
        
        var sqlStr = "UPDATE tblJobs SET status = 3, actualStartDate = '"
        sqlStr += _tblJobs["actualStartDate"] as! String + "', actualEndDate = '"
        sqlStr += _tblJobs["actualEndDate"] as! String + "', completionDetails = '"
        sqlStr += _tblJobs["completionDetails"] as! String  + "', deficiencies = '"
        sqlStr += _tblJobs["deficiencies"] as! String + "' "
        sqlStr += "WHERE id = '" + String(globals.currentJobID) + "'"
        
        //update table
        updateTableJobs(sqlStr: sqlStr)
    }
    
    //accept report routine
    private func btnAcceptReportRoutine() {
        
        let sqlStr = "UPDATE tblJobs SET status = 5 WHERE id = '" + String(globals.currentJobID) + "'"
        
        //update table
        updateTableJobs(sqlStr: sqlStr)
        
    }
    
    //show/hide buttons
    private func enableDisableButtons() {
        
        if globals.currentJobStatusID == 3 {
            uiViewSubmitReport.isHidden = true
        } else {
            uiVIewAcceptReport.isHidden = true
            //uiViewDisputeReport.isHidden = true
        }
    }
    
    //update database
    private func updateTableJobs(sqlStr: String) {
        //open db or create when not yet available
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.updateTable(queryStr: sqlStr) {
                //show home screen
                showNextScreen(screenName: "HomeScreenViewController")
            }
        } else {
            print("cannot connect to database")
        }
        
    }
    
    //initialize screen
    private func initializeScreen() {
        
        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        //get current data
        let dbController = DBController()
        dbController.fetchCurrentJobData()
        
        //set data display
        setDataOnTextFields()
        
        //set up date input fields
        setUpDateInputTextFields()
        
        //set up buttons
        enableDisableButtons()
        
    }
}
