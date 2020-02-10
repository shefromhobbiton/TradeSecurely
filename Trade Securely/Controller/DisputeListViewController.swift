//
//  DisputeListViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 21/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class DisputeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let utils = Utils()
    let dbController = DBController()
    let isNew = true
    
    @IBOutlet weak var tblViewDisputeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewDisputeList.dataSource = self
        tblViewDisputeList.delegate = self
        
        // Do any additional setup after loading the view.
        //setup navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationStyles()
        
        //get data
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _tblDisputeList = [clsDisputes]()
        fetchData()
        tblViewDisputeList.dataSource = self
        tblViewDisputeList.delegate = self
        tblViewDisputeList.reloadData()
    }
    
    //set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _tblDisputeList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tempList: clsDisputes
        tempList = _tblDisputeList[indexPath.row]
        let cellDisputes = Bundle.main.loadNibNamed("TableViewDisputeCell", owner: self, options: nil)?.first as! TableViewDisputeCell
        cellDisputes.lblDisputeID.text = String(tempList.id)
        cellDisputes.lblDisputeName.text = globals.currentJobName
        cellDisputes.lblDisputeStatus.text = dbController.getDisputeStatus(status: tempList.disputeStatus)
        
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
        getCurrentDisputeRecord(list: _tblDisputeList[indexPath.row])
        
        //show next screen
        showNextScreen(screenName: "RaiseDisputeViewController")
    }
    
    //************************* USER DEFINED FUNCTIONS **********************************//
    @objc func createDisputeEvent() {
        //set editing
        globals.isEdit = false
        
        //set dispute status
        globals.currentDisputeStatus = 0
        
        //show next screen
        showNextScreen(screenName: "RaiseDisputeViewController")
    }
    
    private func getCurrentDisputeRecord(list: clsDisputes)
    {
        //set jobID for reading/fetching data
        _tblDisputes = [ "id" : 0,
                         "jobID" : 0,
                         "disputeStatus": 0,
                         "natureOfDispute" : "",
                         "description" : "",
                         "proposedResolution" : ""] as [String : Any]
        
        _tblDisputes["id"] = list.id
        _tblDisputes["jobID"] = list.jobID
        _tblDisputes["disputeStatus"] = list.disputeStatus
        _tblDisputes["natureOfDispute"] = list.natureOfDispute
        _tblDisputes["description"] = list.description
        _tblDisputes["proposedResolution"] = list.proposedResolution
        
        //set globals
        globals.currentDisputeStatus = list.disputeStatus
        globals.currentDisputeID = list.id
    }
    
    //fetch data from table
    private func fetchData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblDispute WHERE jobID = '" + String(globals.currentJobID) + "'"
                dbController.readFromTableDisputes(queryStr: sqlString)
            }
        }
    }
    
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Disputes" //globals.screenName
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createDisputeEvent))
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

