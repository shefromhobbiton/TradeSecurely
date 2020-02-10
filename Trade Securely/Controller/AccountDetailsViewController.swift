//
//  AccountDetailsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 04/12/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class AccountDetailsViewController: UIViewController {

    let utils = Utils()
    let dbController = DBController()
    
    @IBOutlet weak var txtFldUsername: UITextField!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    @IBOutlet weak var txtFldCompanyName: UITextField!
    @IBOutlet weak var txtFldACN: UITextField!
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var txtFldPosition: UITextField!
    @IBOutlet weak var txtFldTel: UITextField!
    @IBOutlet weak var txtFldMobile: UITextField!
    
    @IBOutlet weak var btnHomeOwner: UIButton!
    @IBOutlet weak var btnHomeBuilder: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var vwCompanyName: UIView!
    @IBOutlet weak var vwACN: UIView!
    @IBOutlet weak var vwPosition: UIView!
    
    @IBOutlet weak var lblHomeOwner: UILabel!
    @IBOutlet weak var lblHomeBuilder: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeScreen()
        
    }
    
    @IBAction func btnHomeOwner(_ sender: Any) {
        if btnHomeOwner.isSelected == false {
            btnHomeOwner.isSelected = true
            btnHomeBuilder.isSelected = false
            
            //set text color
            lblHomeOwner.textColor = UIColor.orange
            lblHomeBuilder.textColor = UIColor.black
        }
    }
    
    @IBAction func btnHomeBuilder(_ sender: Any) {
        if btnHomeBuilder.isSelected == false {
            btnHomeBuilder.isSelected = true
            btnHomeOwner.isSelected = false
            
            //set text color
            lblHomeBuilder.textColor = UIColor.orange
            lblHomeOwner.textColor = UIColor.black
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        saveButtonRoutine()
    }
    
    //*******************************  USER DEFIEND FUNCTIONS *******************************/
    private func updateTable()->Bool {
        var sqlStr = ""
        
        if _currentType == 1 {  //home owner
            sqlStr = "UPDATE tblHomeOwner SET fName = '"
            sqlStr += txtFldFirstName.text! as String + "', lName = '"
            sqlStr += txtFldLastName.text! as String + "', email = '"
            sqlStr += txtFldEmail.text! as String + "', password = '"
            sqlStr += txtFldPassword.text! as String + "', address = '"
            sqlStr += txtFldAddress.text! as String + "', phoneNumber = '"
            sqlStr += txtFldTel.text! as String + "', mobileNumber = '"
            sqlStr += txtFldMobile.text! as String + "' "
            sqlStr += "WHERE username = '" + _currentUsername + "'"
        } else { //homebuilder
            sqlStr = "UPDATE tblHomeBuilder SET fName = '"
            sqlStr += txtFldFirstName.text! as String + "', lName = '"
            sqlStr += txtFldLastName.text! as String + "', companyName = '"
            sqlStr += txtFldCompanyName.text! as String + "', ACN = '"
            sqlStr += txtFldACN.text! as String + "', email = '"
            sqlStr += txtFldEmail.text! as String + "', phoneNumber = '"
            sqlStr += txtFldTel.text! as String + "', mobileNumber = '"
            sqlStr += txtFldMobile.text! as String + "', password = '"
            sqlStr += txtFldPassword.text! as String + "', address = '"
            sqlStr += txtFldAddress.text! as String + "' "
            sqlStr += "WHERE username = '" + _currentUsername + "'"
        }
        
        if dbController.openDatabaseFile() == true {
            if dbController.updateTable(queryStr: sqlStr) {
                return true
            }
        } else {
            print("cannot connect to database")
        }
        return false
    }
    
    
    //check if data is complete
    private func checkUserInputs()->Bool {
        if txtFldFirstName.text?.count == 0 {
            return false
        }
        
        if txtFldLastName.text?.count == 0 {
            return false
        }
        
        if txtFldPassword.text?.count == 0 {
            return false
        }
        
        if txtFldConfirmPassword.text?.count == 0 {
            return false
        }
        
        if txtFldAddress.text?.count == 0 {
            return false
        }
        
        if txtFldTel.text?.count == 0 {
            return false
        }
        
        if txtFldMobile.text?.count == 0 {
            return false
        }
        
        if _currentType == 2 {
            if txtFldCompanyName.text?.count == 0 {
                return false
            }
            
            if txtFldACN.text?.count == 0 {
                return false
            }
            
            if txtFldPosition.text?.count == 0 {
                return false
            }
        }
        
        return true
        
    }
    
    //check if password matches
    private func checkPasswordMatch()->Bool {
        let passwordA = txtFldPassword.text
        let passwordB = txtFldConfirmPassword.text
        let matched = (passwordA == passwordB)
        return matched
    }
    
    //update placeholder
    private func updatePlaceholder() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                if _currentType == 1 {
                    let sqlStr = "SELECT * FROM tblHomeOwner WHERE username = '" + _currentUsername + "'"
                    _ = dbController.readFromTableHomeOwner(queryStr: sqlStr)
                } else {
                    let sqlStr = "SELECT * FROM tblHomeBuilder WHERE username = '" + _currentUsername + "'"
                    _ = dbController.readFromTableHomeBuilder(queryStr: sqlStr)
                }
                
            }
        } else {
            print("DB creation failed")
        }
    }
    
    //save routine
    private func saveButtonRoutine() {
        //check if all data are filled up
        if checkUserInputs() {
            //check if passwords matches
            if checkPasswordMatch() {
                //update record
                if updateTable() {
                    //update placeholders
                    updatePlaceholder()
                    
                    //return to variation list
                    _ = navigationController?.popToRootViewController(animated: true) //return to previous screen
                } else {
                    //show alert
                    let alert = utils.showOKAlert(title: "Database Error", message: "There was an error trying to update the database.")
                    present(alert, animated: true)
                }
            } else {
                //show alert
                let alert = utils.showOKAlert(title: "Password does not match.", message: "Please enter your desired password again.")
                present(alert, animated: true)
            }
        } else {
            //show alert
            let alert = utils.showOKAlert(title: "Incomplete Deatils", message: "Please fill up all the required information.")
            present(alert, animated: true)
        }
    }
    
    //hide homebuilder related data
    private func hideTextFields() {
        vwCompanyName.isHidden = true
        vwACN.isHidden = true
        vwPosition.isHidden = true
    }
    
    //set data on textfields
    private func setDataOnTextField() {
        
        if _currentType == 1 { //home owner
            
            let list: clsHomeOwner
            if _tblCurrentHomeOwnerData.count > 0 {
                list =  _tblCurrentHomeOwnerData[_tblCurrentHomeOwnerData.count - 1]
                txtFldUsername.text = list.username
                txtFldFirstName.text = list.fName
                txtFldLastName.text = list.lName
                txtFldEmail.text = list.email
                txtFldPassword.text = list.password
                txtFldConfirmPassword.text = list.password
                txtFldAddress.text = list.address
                txtFldTel.text = list.phoneNumber
                txtFldMobile.text = list.mobileNumber
                
                //set radio button
                btnHomeOwner.isSelected = true
                lblHomeOwner.textColor = UIColor.orange
            }
        } else { //home builder
            
            let list: clsHomeBuilder
            
            if _tblCurrentHomeBuilderData.count > 0 {
                list = _tblCurrentHomeBuilderData[_tblCurrentHomeBuilderData.count - 1]
                txtFldUsername.text = list.username
                txtFldFirstName.text = list.fName
                txtFldLastName.text = list.lName
                txtFldEmail.text = list.email
                txtFldPassword.text = list.password
                txtFldConfirmPassword.text = list.password
                txtFldCompanyName.text = list.companyName
                txtFldACN.text = list.ACN
                txtFldAddress.text = list.address
                txtFldPosition.text = list.positionHeld
                txtFldTel.text = list.phoneNumber
                txtFldMobile.text = list.mobileNumber
                
                //set radio button
                btnHomeBuilder.isSelected = true
                lblHomeBuilder.textColor = UIColor.orange
            } else {
                print("no record found")
            }
        }
    }
    
    //initialize screen display
    private func initializeScreen() {
        
        //set up navigation
        setUpNavigationStyles()
        
        //check current user type
        if _currentType == 1 {  //homeowner
            //hide unnecessary views
            hideTextFields()
        }
        
        //set data on textfields
        setDataOnTextField()
        
        //disbale editing
        enabDisableEditing(enable: false)
        
        //hide save button
        btnSave.isHidden = true
    }
    
    //disable editing on textfields
    private func enabDisableEditing(enable: Bool) {
        
        //txtFldUsername.text = list.username
        txtFldFirstName.isUserInteractionEnabled = enable
        txtFldLastName.isUserInteractionEnabled = enable
        //txtFldEmail.text = list.email
        txtFldPassword.isUserInteractionEnabled = enable
        txtFldConfirmPassword.isUserInteractionEnabled = enable
        txtFldCompanyName.isUserInteractionEnabled = enable
        txtFldACN.isUserInteractionEnabled = enable
        txtFldAddress.isUserInteractionEnabled = enable
        txtFldPosition.isUserInteractionEnabled = enable
        txtFldTel.isUserInteractionEnabled = enable
        txtFldMobile.isUserInteractionEnabled = enable
    }
    
    @objc func btnEditDetailsEvent() {
        
        //allow edit on textfields
        enabDisableEditing(enable: true)
        
        //show save button
        btnSave.isHidden = false
        
        //hide edit button
        self.navigationItem.rightBarButtonItem?.title = ""
    }
    
    //set up navigation
    private func setUpNavigationStyles() {
        
        //make navigation controller animated
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Edit Account Details"
        self.navigationItem.backBarButtonItem?.title = " "
        
        //set right button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(btnEditDetailsEvent))
        
    }

}
