//
//  MyWalletViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 14/01/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    let utils = Utils()
    
    @IBOutlet weak var txtFldBalance: UITextField!
    @IBOutlet weak var txtFldDepositsMade: UITextField!
    @IBOutlet weak var txtFldMoneyReleased: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        //set up screen
        initializeScreen()
    }
    
    @IBAction func txtFldBalance(_ sender: Any) {
//        if txtFldFees.text?.count ?? 0 > 3 {
//            lblTotal.text = utils.formatNumber(numValue: Int(txtFldFees.text!)!)
//        } else {
//            lblTotal.text = txtFldFees.text
//        }
    }
    
    @IBAction func txtFldDepositsMade(_ sender: Any) {
        
    }
    
    @IBAction func txtFldMoneyReleased(_ sender: Any) {
        
    }
    //*********************** USER DEFINED FUNCTIONS ***************************//
    //initialize screen
    private func initializeScreen() {
        
        //set thousands separator on amount
        if txtFldBalance.text?.count ?? 0 > 3 {
            txtFldBalance.text = utils.formatNumber(numValue: Int(txtFldBalance.text!)!)
        }
   
        if txtFldDepositsMade.text?.count ?? 0 > 3 {
            txtFldDepositsMade.text = utils.formatNumber(numValue: Int(txtFldDepositsMade.text!)!)
        }
        
        if txtFldMoneyReleased.text?.count ?? 0 > 3 {
            txtFldMoneyReleased.text = utils.formatNumber(numValue: Int(txtFldMoneyReleased.text!)!)
        }
    }
    
    private func setUpNavigationStyles() {
        //make navigation controller animated
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "My Wallet"
        self.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    //move to next screen
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
