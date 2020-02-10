//
//  VariationAddSignatureViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 03/12/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class VariationAddSignatureViewController: UIViewController {

    let utils = Utils()
    let dbController = DBController()
    
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var btnConfirmVariation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeScreen()
    }
    
    @IBAction func btnCheckbox(_ sender: Any) {
        btnCheckbox.isSelected = !btnCheckbox.isSelected
    }
    
    @IBAction func btnConfirmVariation(_ sender: Any) {
        self.confirmVariation()
    }
    
    //************************************** USER DEFINED FUNCTIONS **************************************//
    //check for user input completenes
    func checkUserInput()->Bool {
        if btnCheckbox.isSelected {
            return true
        } else {
            return false
        }
    }
    
    //on submit job event
    private func confirmVariation() {
        
        if checkUserInput() {
            var sqlStr = "UPDATE tblVariation SET variationStatus = 4 "
            sqlStr += "WHERE id = \(_tblVariations["id"]!)"
            
            if dbController.openDatabaseFile() == true {
                if dbController.updateTable(queryStr: sqlStr) {
                    //return to variation list
                    _ = navigationController?.popToRootViewController(animated: true) //return to previous screen
                }
            } else {
                print("cannot connect to database")
            }
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "You must agree to Trade Securely's General and Payment Terms of Service and  Privacy Policy to continue.")
            present(alert, animated: true)
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

    }

}
