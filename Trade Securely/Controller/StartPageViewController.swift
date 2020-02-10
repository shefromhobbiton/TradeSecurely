//
//  LogInViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 24/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set up navigation bar
        
        
        //set up navigation bar
        setUpNavBar()
        
        //set up db
        setUpDB()
        
    }
    
    
    /******************* USER DEFINED FUNCTIONS **********************/
    
    private func setUpNavBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor .orange
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    private func setUpDB() {
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            print("DB creation successfull")
            
            if dbController.createTable() == true {
                print("create table successful.")
            }
        } else {
            print("DB creation failed")
        }
    }
}
