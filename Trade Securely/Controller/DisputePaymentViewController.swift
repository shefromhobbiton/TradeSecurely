//
//  DisputePaymentViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 09/01/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class DisputePaymentViewController: UIViewController {

    @IBOutlet weak var txtFldJobName: UITextField!
    @IBOutlet weak var txtFldFees: UITextField!
    @IBOutlet weak var lblJobName: UITextField!
    @IBOutlet weak var lblTotal: UITextField!
   
    @IBOutlet weak var lblCreditCard: UILabel!
    @IBOutlet weak var lblPaypal: UILabel!
    @IBOutlet weak var lblInternetBanking: UILabel!
    
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnInternetBanking: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    let utils = Utils()
    var paymentOption: Int = 0  //1 - Credit Card, 2 - Paypal, 3 - Internet Banking
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        initializeScreen()
    }
    
    @IBAction func txtFldFees(_ sender: Any) {
        if txtFldFees.text?.count ?? 0 > 3 {
            lblTotal.text = utils.formatNumber(numValue: Int(txtFldFees.text!)!)
        } else {
            lblTotal.text = txtFldFees.text
        }
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
    
    
    @IBAction func btnNextEvent(_ sender: Any) {
        
        print("return to job list")
        if let composeViewController = self.navigationController?.viewControllers[1] {//Here you mention your view controllers index, because navigation controller can store all VC'c in an array.
            print(composeViewController)
            self.navigationController?.popToViewController(composeViewController, animated: true)
        }
    }
    
    
    //*********************** USER DEFINED FUNCTIONS ***************************//
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Job Payment"
        self.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    //move to next screen
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func initializeScreen() {
        
        //set job name
        lblJobName.text = globals.currentJobName
    }
    

}
