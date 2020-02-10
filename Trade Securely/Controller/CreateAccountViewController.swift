//
//  ViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 24/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblViewDetails: UITableView!
    @IBOutlet weak var btnHomeOwner: UIButton!
    @IBOutlet weak var btnHomeBuilder: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblHomeOwner: UILabel!
    @IBOutlet weak var lblHomeBuilder: UILabel!
    
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation styles
        setUpNavigationStyles()
        
        //set up screen
        initializeScreen()
        
    }
    
    //set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //populate table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: //username
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Username"
            cell.selectionStyle = .none
            return cell
        case 1: //first name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "First Name"
            cell.selectionStyle = .none
            return cell
        case 2: //last name name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Last Name"
            cell.selectionStyle = .none
            return cell
        case 3: //email
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Email"
            cell.selectionStyle = .none
            return cell
        case 4: ///password
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Password"
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    @IBAction func btnHomeOwner(_ sender: UIButton) {
        if btnHomeOwner.isSelected == false {
            btnHomeOwner.isSelected = true
            btnHomeBuilder.isSelected = false
            
            //set text color
            lblHomeOwner.textColor = UIColor.orange
            lblHomeBuilder.textColor = UIColor.black
            
            //set current type
            _currentType = 1
        }
    }
    
    @IBAction func btnHomeBuilder(_ sender: UIButton) {
        if btnHomeBuilder.isSelected == false {
            btnHomeBuilder.isSelected = true
            btnHomeOwner.isSelected = false
            
            //set text color
            lblHomeOwner.textColor = UIColor.black
            lblHomeBuilder.textColor = UIColor.orange
            
            //set current type
            _currentType = 2
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        
        print(">>>>>>>>>>>>>>  NEXT BUTTON <<<<<<<<<<<<<<")
        //copy user inputs
        if copyUserInput() == true {
        
            if checkIfUserExist() == true {
                //show alert
                let alert = utils.showOKAlert(title: "Username already exist", message: "Please select a different username.")
                present(alert, animated: true)
            } else {
                //show next screen
                if btnHomeOwner.isSelected == true {
                    //set current user type
                    _currentType = 1
                    
                    //show AccountSetUpHomeOwner screen
                    showNextScreen(screenName: "AccountSetUpHomeOwnerViewController")
                } else {
                    //set current user type
                    _currentType = 2
                    
                    //show AccountSetUpHomeBuilder screen
                    showNextScreen(screenName: "AccountSetUpHomeBuilderViewController")
                }
            }
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please fill up all the required information")
            present(alert, animated: true)
            
        }
    }
 
    /******************* USER DEFINED FUNCTIONS **********************/
    
    //set up navigation bar
    func setUpNavigationStyles() {
        
        //set
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Create Account"
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //load view routine
    func initializeScreen() {
        
        //register tableview cells
        tblViewDetails.register(UINib.init(nibName:"TableViewInputCell", bundle: nil), forCellReuseIdentifier: "TableViewInputCell")
        
        //set up table
        tblViewDetails.dataSource = self
        tblViewDetails.delegate = self
        
        //set default radio button
        btnHomeOwner.isSelected = true
    }
    
    //show new screen
    private func showNextScreen( screenName: String ) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //store user inputs to placeholders
    private func copyUserInput()->Bool {
        
        //store values to placeholders
        for ctr in 0...4 {
            let ndxPath = NSIndexPath(row: ctr, section: 0)
            let tempCell = tblViewDetails.cellForRow(at: ndxPath as IndexPath) as! TableViewInputCell
            
            switch ctr {
            case 0:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _username = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            case 1:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _fname = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            case 2:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _lname = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            case 3:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _email = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            default:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _password = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    //check if username has already been taken
    func checkIfUserExist()->Bool {
        //check if chosen username already exist
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            print("DB creation successfull")
            
            if dbController.createTable() == true {
                print("create table successful.")
                var sqlString: String = ""
                
                if btnHomeOwner.isSelected == true {
                    sqlString = "SELECT * FROM tblHomeOwner where username = '" + _username + "'"
                } else {
                    sqlString = "SELECT * FROM tblHomeBuilder where username = '" + _username + "'"
                }
                
                print("sqlString -> ", sqlString)
                if dbController.checkUser(queryStr: sqlString) == true {
                    return true
                }
            }
        } else {
            print("DB creation failed")
            return false
        }
        return false
    }
}

