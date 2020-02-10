//
//  DeclineJobsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 15/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class DeclineJobsViewController: UIViewController {

    @IBOutlet weak var txtViewComments: UITextView!
    @IBOutlet weak var btnConfirmDecline: UIButton!
    
    let utils = Utils()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationStyles()
    }
    
    @IBAction func btnConfirmDecline(_ sender: Any) {
        btnConfirmDeclineRoutine()
    }
    
   /******************** USER DEFINED FUNCTIONS ***********************/
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Decline Job" //globals.screenName
        self.navigationItem.backBarButtonItem?.title = " "
    }

    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func btnConfirmDeclineRoutine() {
        //get data
        getDataFromTextView()
        
        //save data
        saveDataToTable()
    }
    
    func getDataFromTextView() {
        _tblJobs["declineComment"] = txtViewComments.text
    }
    
    func saveDataToTable() {
        
        var sqlStr = "UPDATE tblJobs SET status = 4, declineComment = '"
        sqlStr += _tblJobs["declineComment"] as! String
        sqlStr += "' WHERE id = " + String(globals.currentJobID)
        
        //update table
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
}
