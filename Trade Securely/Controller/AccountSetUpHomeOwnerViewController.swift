//
//  AccountSetUpHomeOwnerViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 27/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class AccountSetUpHomeOwnerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblViewHomeOwnerDetails: UITableView!
    @IBOutlet weak var btnSignUp: UIButton!
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set up nav styles
        setUpNavBar()
        
        //set up screen
        initializeScreen()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: //username
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Address"
            cell.selectionStyle = .none
            return cell
        case 1: //first name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Tel"
            cell.selectionStyle = .none
            return cell
        case 2: //last name name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Mobile"
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    //on button SignUp Event
    @IBAction func btnSignUp(_ sender: Any) {
        
        //sign up routine
        if copyUserInput() {
            //save data to table
            saveDataToTable()
        } else {
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please fill up all the required information")
            present(alert, animated: true)
        }
    }
    
    /******************* USER DEFINED FUNCTIONS **********************/
    
    // set up navigation style
    func setUpNavBar() {
        //set navigation styles
        let utils = Utils()
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Create Account"
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //set up screen
    func initializeScreen() {
        //register tableview cells
        tblViewHomeOwnerDetails.register(UINib.init(nibName:"TableViewInputCell", bundle: nil), forCellReuseIdentifier: "TableViewInputCell")
        
        // Do any additional setup after loading the view.
        tblViewHomeOwnerDetails.dataSource = self
        tblViewHomeOwnerDetails.delegate = self
    }
    
    //store user inputs to placeholders
    private func copyUserInput()->Bool {
        
        //store values to collections
        for ctr in 0...2 {
            let ndxPath = NSIndexPath(row: ctr, section: 0)
            let tempCell = tblViewHomeOwnerDetails.cellForRow(at: ndxPath as IndexPath) as! TableViewInputCell
            
            switch ctr {
            case 0:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _tblHomeOwner["address"] = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            case 1:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _tblHomeOwner["phoneNumber"] = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            default:
                if tempCell.txtFieldDetails.text!.count > 0 {
                    _tblHomeOwner["mobileNumber"] = tempCell.txtFieldDetails.text!
                } else {
                    return false
                }
            }
        }
        
        //copy data to collection
        _tblHomeOwner["username"] = _username
        _tblHomeOwner["fName"] = _fname
        _tblHomeOwner["lName"] = _lname
        _tblHomeOwner["email"] = _email
        _tblHomeOwner["password"] = _password
        _tblHomeOwner["paymentOptionId"] = 0
        
        print("username -> ",  _tblHomeOwner["username"]!)
        print("fname -> ",  _tblHomeOwner["fName"]!)
        print("lname -> ", _tblHomeOwner["lName"]!)
        print("email -> ", _tblHomeOwner["email"]!)
        print("password -> ", _tblHomeOwner["password"]!)
        print("address -> ", _tblHomeOwner["address"] as Any)
        print("telephone -> ", _tblHomeOwner["phoneNumber"] as Any)
        print("mobile -> ", _tblHomeOwner["mobileNumber"] as Any)
        
        
        //set up current variables
        _currentUsername = _username
        _currentFName = _fname
        _currentLName = _lname
        
        return true
    }
    
    //save data to table
    func saveDataToTable() {
        //open db or create when not yet available
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.saveHomeOwnerDataToDB() == true {
                
                let alert = UIAlertController(title: "Success", message:   "Welcome To Trade Securely!", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                    self.showMainScreen()
                })
                
                alert.addAction(OKAction)
                self.present(alert, animated: true){}
                
            }
        } else {
            print("cannot connect to database")
        }
    }
    
    //show new screen
    private func showMainScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenViewController")
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
