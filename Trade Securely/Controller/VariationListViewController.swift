//
//  VariationListViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 02/12/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class VariationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let utils = Utils()
    let dbController = DBController()
    let isNew = true

    @IBOutlet weak var tblViewVariationList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.tblViewVariationList.dataSource = self
        self.tblViewVariationList.delegate = self
        
        // Do any additional setup after loading the view.
        //setup navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationStyles()
        
        //get data
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        self.tblViewVariationList.dataSource = self
        self.tblViewVariationList.delegate = self
        self.tblViewVariationList.reloadData()
    }
    
    //set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _tblVariationList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tempList: clsVariations
        tempList = _tblVariationList[indexPath.row]
        
        //reuse TableViewInputCell
        let cellDisputes = Bundle.main.loadNibNamed("TableViewDisputeCell", owner: self, options: nil)?.first as! TableViewDisputeCell
        cellDisputes.lblDisputeID.text = String(tempList.id)
        cellDisputes.lblDisputeName.text = tempList.natureOfVariation
        cellDisputes.lblDisputeStatus.text = dbController.getVariationStatus(status: tempList.variationStatus)
        
        //set bg color
        if indexPath.row % 2 == 0 {
            cellDisputes.backgroundColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0) //UIColor.lightGray
        } else {
            cellDisputes.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0) //UIColor.gray
        }
        
        return cellDisputes
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set editing to true
        globals.isEdit = true
        
        //remove highlight after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        //get current record details
        getCurrentVariationRecord(list: _tblVariationList[indexPath.row])
        
        //show next screen
        showNextScreen(screenName: "VariationViewController")
    }
    
    //********************************* USER DEFINED FUNCTIONS ********************************//
    @objc func createVariationEvent() {
        //set editing
        globals.isEdit = false
        
        //show next screen
        showNextScreen(screenName: "VariationViewController")
    }
    
    //get current variation record
    private func getCurrentVariationRecord(list: clsVariations)
    {
        //set jobID for reading/fetching data
        _tblVariations = [ "id" : 0,
                           "jobID" : 0,
                           "variationStatus": 0,
                           "natureOfVariation" : "",
                           "description" : "",
                           "cost" : 0] as [String : Any]
        
        _tblVariations["id"] = list.id
        _tblVariations["jobID"] = list.jobID
        _tblVariations["variationStatus"] = list.variationStatus
        _tblVariations["natureOfVariation"] = list.natureOfVariation
        _tblVariations["description"] = list.description
        _tblVariations["cost"] = list.cost
        
    }
    
    //fetch data from table
    private func fetchData() {
        
        //initialize container
        _tblVariationList = [clsVariations]()
        
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblVariation WHERE jobID = '" + String(globals.currentJobID) + "'"
                dbController.readFromTableVariation(queryStr: sqlString)
            }
        }
    }
    
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Variations" //globals.screenName
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createVariationEvent))
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
