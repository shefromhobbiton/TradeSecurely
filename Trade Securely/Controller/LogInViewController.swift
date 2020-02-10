//
//  LogInViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 27/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var fbLogInContainer: UIView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var btnLogIn: UIButton!
    //@IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //clear text if any
        txtFieldUsername.text = ""
        txtFieldPassword.text = ""
        
        //hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func checkBoxSelectEvent(_ sender: UIButton) {
        
        if checkBox.isSelected == true {
            //set to false
            checkBox.isSelected = false
        } else {
            checkBox.isSelected = true
        }
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        self.logInRoutine()
    }

    /******************* USER DEFINED FUNCTIONS **********************/
    func logInRoutine() {
        //fetch user input
        let username = txtFieldUsername.text!
        let password = txtFieldPassword.text!
        
        if self.checkRecordFromTableHomeOwner(username: username, password: password) == false {
            if self.checkRecordFromTableHomeBuilder(username: username, password: password) == false {
                let alert = UIAlertController(title: "Error Logging In", message:   "Incorrect username/password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                self.present(alert, animated: true){}
            } else {
                self.showMainScreen()
            }
        } else {
            self.showMainScreen()
        }
    }
    
    //sign up routine
    private func btnSignUpRoutine() {
        showNextScreen(screenName: "CreateAccountViewController")
    }
    
    //show main screen
    private func showMainScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newNavigationController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenNavigationController")
        self.present(newNavigationController, animated: true, completion: nil)
    }
    
    //show next screen
    func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //check credentials if valid
    func checkRecordFromTableHomeOwner(username: String, password:String)->Bool {
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlStr = "SELECT * FROM tblHomeOwner WHERE username = '" + username + "' AND password = '" + password + "'"
                print("sqlStr -> ", sqlStr)
                if dbController.readFromTableHomeOwner(queryStr: sqlStr) {
                    
                    //set routine type
                    _currentType = 1  //homeowner
                    return true
                    
                } else {
                    return false
                }
            }
        } else {
            print("DB creation failed")
            return false
        }
        return false
    }
    
    func checkRecordFromTableHomeBuilder(username: String, password:String)->Bool {
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                //check from tblHomeBuilder
                let sqlStr = "SELECT * FROM tblHomeBuilder WHERE username = '" + username + "' AND password = '" + password + "'"
                if dbController.readFromTableHomeBuilder(queryStr: sqlStr){
                    //set routine type
                    _currentType = 2  //homeowner
                    return true
                } else {
                    print("no record found")
                    return false
                }
            }
        } else {
            print("DB creation failed")
            return false
        }
        
        return false
    }
}
