//
//  SearchJobsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 18/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class SearchJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblViewJobs: UITableView!
    
    let utils = Utils()
    let dbController = DBController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tblViewJobs.delegate = self
        self.tblViewJobs.dataSource = self
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationStyles()
        
        //fetch data from table
        fetchData()
        
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
        let cellJobs = Bundle.main.loadNibNamed("TableViewJobsCell", owner: self, options: nil)?.first as! TableViewJobsCell
        cellJobs.lblID.text = String(_tblJobList[indexPath.row].id)
        cellJobs.lblJobName.text = _tblJobList[indexPath.row].jobName
        cellJobs.lblStatus.text = dbController.getJobStatus(status:_tblJobList[indexPath.row].status)
        
        if indexPath.row % 2 == 0 {
            cellJobs.backgroundColor = UIColor.lightGray
        } else {
            cellJobs.backgroundColor = UIColor.gray
        }
        
        return cellJobs
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //remove highlight after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        var list: clsJobs
        list = _tblJobList[indexPath.row]
        
        //set jobID for reading/fetching data
        utils.setRequiredGlobals(jobID: list.id, jobStatus: list.status, currentAction: 1)  // current action 1 for search
        
        //show View Jobs Screen
        showNextScreen(screenName: "CreateJobViewController")
    }
    
    /*************  USER DEFINED FUNCTIONS ****************/
    func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Search Jobs"
        self.navigationItem.backBarButtonItem?.title = "Back"
    }

    //fetch data from table
    func fetchData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblJobs WHERE jobCreatorType = '" +  String(_currentType) + "' AND jobCreatorUsername = '" + _currentUsername + "'"
                dbController.readFromTableJobs(queryStr: sqlString)
            }
        }
    }
    
    //move to next screen
    //show next screen
    func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
