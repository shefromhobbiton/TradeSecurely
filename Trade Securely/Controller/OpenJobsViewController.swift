//
//  OpenJobsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 01/11/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class OpenJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblViewJobList: UITableView!
    
    let utils = Utils()
    let dbController = DBController()
    var screenTitle = ""  //set screen title based from which function called
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
        initializeScreen()
        
    }
    
    //set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _tblJobList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tempList: clsJobs
        tempList = _tblJobList[indexPath.row]
        let cellJobs = Bundle.main.loadNibNamed("TableViewOpenJobsCell", owner: self, options: nil)?.first as! TableViewOpenJobsCell
        cellJobs.lblJobID.text = String(tempList.id)
        cellJobs.lblProjName.text = tempList.projectName
        cellJobs.lblJobName.text = tempList.jobName
        cellJobs.lblStatus.text = dbController.getJobStatus(status: tempList.status)
        
        if indexPath.row % 2 == 0 {
            cellJobs.backgroundColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0) //UIColor.lightGray
        } else {
            cellJobs.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0) //UIColor.gray
        }
        
        return cellJobs
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //remove highlight after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        var list: clsJobs
        list = _tblJobList[indexPath.row]
        
        //TEMP:
        globals.currentJobName = list.jobName
        
        //set jobID for reading/fetching data
        utils.setRequiredGlobals(jobID: list.id, jobStatus: list.status, currentAction: 2) // current action 2 - open jobs
        
        //show next screen
        if globals.isFromHomeMenu {  //called from home menu items
            //show variation list
            if globals.whichList == 1 {
                showNextScreen(screenName: "DisputeListViewController")
            } else {
                showNextScreen(screenName: "VariationListViewController")
            }
            
        } else {
            //// 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed", 6 - "Pending Payment"
            if list.status == 1 || list.status == 2 {
                globals.screenName = "Review Job Details"
                showNextScreen(screenName: "CreateJobViewController")
            } else if list.status == 3 {
                globals.screenName = "Completion Report"
                showNextScreen(screenName: "CompletionReportViewController")
            } else if list.status == 6 {
                globals.screenName = "Job Payment"
                showNextScreen(screenName: "JobPaymentViewController")
            }
        }
    }
    
    /********************* USER DEFINED FUNCTIONS *************************/
    //initialize screen
    private func initializeScreen() {
        
        if globals.isFromHomeMenu {
            screenTitle = "Select Job"
        } else {
            screenTitle = "Open Jobs"
        }
        
        //set up nav bar
        setUpNavigationStyles()
        
        //fetch Data
        fetchData()
        
        //initialize table
        tblViewJobList.dataSource = self
        tblViewJobList.delegate = self
    }
    
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = screenTitle
        //self.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    //move to next screen
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //fetch data from table
    private func fetchData() {
        
        var sqlString = ""
        
        if globals.isFromHomeMenu { //called from home menu item
            sqlString = "SELECT * FROM tblJobs WHERE status IN (2,3)"
        } else { //called from home buttons
            sqlString = "SELECT * FROM tblJobs WHERE status IN (1,2,3,6)"
        }
        
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                dbController.readFromTableJobs(queryStr: sqlString)
            }
        }
    }
}
