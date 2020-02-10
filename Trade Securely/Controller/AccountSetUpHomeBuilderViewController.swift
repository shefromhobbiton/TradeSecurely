 //
//  UIViewControllerHomeBuilder.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 27/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class AccountSetUpHomeBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblViewHomeBuilderDetails: UITableView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let utils = Utils()

    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigation styles
        setUpNavBar()
        
        //set up screen
        initializeScreen()
        
    }
    
    
    //set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //populate table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: //username
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Company/Business"
            cell.selectionStyle = .none
            return cell
        case 1: //first name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "ABN/ACN"
            cell.selectionStyle = .none
            return cell
        case 2: //last name name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Address"
            cell.selectionStyle = .none
            return cell
        case 3: //username
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Position Held"
            cell.selectionStyle = .none
            return cell
        case 4: //first name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Tel"
            cell.selectionStyle = .none
            return cell
        case 5: //last name name
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewInputCell") as! TableViewInputCell
            cell.lblDetails.text = "Mobile"
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    //button sign up event
    @IBAction func btnSignUpEvent(_ sender: Any) {
        
        //copy user inputs
        copyUserInput()
        
        //save data to table
        saveDataToTable()
        
    }
    
    /******************* USER DEFINED FUNCTIONS **********************/
    //set up navigation style
    func setUpNavBar() {
        
        //set up nav styles
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Create Account"
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //prepare screen
    func initializeScreen() {
        
        //register tableview cells
        tblViewHomeBuilderDetails.register(UINib.init(nibName:"TableViewInputCell", bundle: nil), forCellReuseIdentifier: "TableViewInputCell")
        
        //set up table view details
        tblViewHomeBuilderDetails.dataSource = self
        tblViewHomeBuilderDetails.delegate = self
    }
    
    //store user inputs to temporary storage
    private func copyUserInput() {
        
        //store values to collections
        for ctr in 0...5 {
            let ndxPath = NSIndexPath(row: ctr, section: 0)
            let tempCell = tblViewHomeBuilderDetails.cellForRow(at: ndxPath as IndexPath) as! TableViewInputCell
            
            switch ctr {
            case 0:
                _tblHomeBuilder["companyName"] = tempCell.txtFieldDetails.text!
            case 1:
                _tblHomeBuilder["ACN"] = tempCell.txtFieldDetails.text!
            case 2:
                _tblHomeBuilder["address"] = tempCell.txtFieldDetails.text!
            case 3:
                _tblHomeBuilder["positionHeld"] = tempCell.txtFieldDetails.text!
            case 4:
                _tblHomeBuilder["phoneNumber"] = tempCell.txtFieldDetails.text!
            default:
                _tblHomeBuilder["mobileNumber"] = tempCell.txtFieldDetails.text!
            }
        }
        
        //copy data to collection
        _tblHomeBuilder["username"] = _username
        _tblHomeBuilder["fName"] = _fname
        _tblHomeBuilder["lName"] = _lname
        _tblHomeBuilder["email"] = _email
        _tblHomeBuilder["password"] = _password
        
        //set up current variables
        _currentUsername = _username
        _currentFName = _fname
        _currentLName = _lname
    }
    
    func saveDataToTable() {
        //open db or create when not yet available
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.saveHomeBuilderDataToDB() == true {
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
