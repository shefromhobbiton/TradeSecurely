//
//  JobPaymentViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 07/01/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class JobPaymentViewController: UIViewController {

    @IBOutlet weak var txtFieldJobName: UITextField!
    @IBOutlet weak var txtFieldAgreedPrice: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnInternetBanking: UIButton!
    @IBOutlet weak var lblCreditCard: UILabel!
    @IBOutlet weak var lblPaypal: UILabel!
    @IBOutlet weak var lblInternetBanking: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    
    let utils = Utils()
    var paymentOption: Int = 0  //1 - Credit Card, 2 - Paypal, 3 - Internet Banking
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        initializeScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set up back button item
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = "Back"
        navigationController?.navigationBar.backItem?.backBarButtonItem = backBarBtnItem
    }
    
    @IBAction func btnCreditCard(_ sender: Any) {
        if !btnCreditCard.isSelected {
            btnCreditCard.isSelected = true
            lblCreditCard.textColor = UIColor.orange
            
            //deselect other buttons
            btnPaypal.isSelected = false
            btnInternetBanking.isSelected = false
            
            //set text color
            lblPaypal.textColor = UIColor.black
            lblInternetBanking.textColor = UIColor.black
            
            //set variable
            paymentOption = 1
        }
    }
    
    @IBAction func btnPaypal(_ sender: Any) {
        
        if !btnPaypal.isSelected {
            btnPaypal.isSelected = true
            lblPaypal.textColor = UIColor.orange
            
            //deselect other buttons
            btnCreditCard.isSelected = false
            btnInternetBanking.isSelected = false
            
            //set text color
            lblCreditCard.textColor = UIColor.black
            lblInternetBanking.textColor = UIColor.black
            
            //set variable
            paymentOption = 2
            
        }
    }
    
    @IBAction func btnInternetBanking(_ sender: Any) {
        
        if !btnInternetBanking.isSelected {
            btnInternetBanking.isSelected = true
            lblInternetBanking.textColor = UIColor.orange
            
            //deselect other buttons
            btnCreditCard.isSelected = false
            btnPaypal.isSelected = false
            
            //set text color
            lblPaypal.textColor = UIColor.black
            lblCreditCard.textColor = UIColor.black
            
            //set variable
            paymentOption = 3
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        
        //do Next button routine
        btnNextEvent()
    }
    
    /********************  USER DEFINED FUNCTIONS *********************/
    private func btnNextEvent() {
        
        if paymentOption > 0 {
            //update job status to active
            //set sqlString
            let sqlStr = "UPDATE tblJobs SET status = 2 WHERE id = '" + String(globals.currentJobID) + "'"
            
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
        } else { //did not select payment method
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please select preferred payment method.")
            present(alert, animated: true)
        }
    }
    
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Job Payment"
        self.navigationItem.backBarButtonItem?.title = ""
        //self.navigationController?.navigationBar.topItem?.title = ""
        //self.navigationItem.backBarButtonItem?.title = backItem
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    //move to next screen
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //initialize Scree
    private func initializeScreen() {
        let dbController = DBController()
        
        //get current data from table
        dbController.fetchCurrentJobData()
        dbController.fetchCurrentPaymentsData()
        
        //set job name
        txtFieldJobName.text = globals.currentJobName
        
        //set agree price - if scheduled, show Payment 1
        if _tblCurrentJobData[0].isProgressBilling == 1 {  //true
            //set label name
            lblPayment.text = "Payment 1"
        }
        
        //set payment amount
        txtFieldAgreedPrice.text = utils.formatNumber(numValue: _tblPaymentList[0].amount)
        
    }

}
