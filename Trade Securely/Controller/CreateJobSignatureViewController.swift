//
//  CreateJobSignatureViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 18/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CreateJobSignatureViewController: UIViewController {

    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var btnSubmitJobRequest: UIButton!
    
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
        initializeScreen()
    }
    
    @IBAction func btnCheckbox(_ sender: Any) {
       btnCheckbox.isSelected = !btnCheckbox.isSelected
    }
    
    @IBAction func btnSubmitJob(_ sender: Any) {
        
        if globals.currentAction == 2 {
            //update jobs table
            updateDataFromTable()
        } else {
            //submit job request
            submitJobRequest()
        }
    }

    /********************* USER DEFINED FUNCTIONS ************************/
    //save user inputs to database tables
    func saveDataToTable() {
        //open db or create when not yet available
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.saveJobsDataToDB() == true {
                let alert = UIAlertController(title: "Job Request Submitted", message: "New job request was sent to your preferred home builder.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                    self.showNextScreen(screenName: "HomeScreenViewController")
                })
                
                alert.addAction(OKAction)
                self.present(alert, animated: true){}
            }
            
        } else {
            print("cannot connect to database")
        }
    }
    
    //update jobs table, set status to active
    func updateDataFromTable() {
        
        //set sqlString
        //let sqlStr = "UPDATE tblJobs SET status = 2 WHERE id = '" + String(globals.currentJobID) + "'"
        let sqlStr = "UPDATE tblJobs SET status = 6 WHERE id = '" + String(globals.currentJobID) + "'"   //status 6 = Pending Payment
        
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
    
    //on submit job event
    func submitJobRequest() {
        if checkUserInput() {
            self.saveDataToTable()
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "You must agree to Trade Securely's General and Payment Terms of Service and  Privacy Policy to continue.")
            present(alert, animated: true)
        }
    }
    
    //check for user input completenes
    func checkUserInput()->Bool {
        
        if btnCheckbox.isSelected {
            return true
        } else {
            return false
        }
    }
    
    //set up navigation
    func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Add Signature"
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //show next screen
    func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //initialize screen
    func initializeScreen() {
        
        //set up navigation style
        setUpNavigationStyles()
        
        //check current action
        if globals.currentAction == 2 {
            btnSubmitJobRequest.setTitle("Accept Job", for: .normal)
        }
    }
    
}
