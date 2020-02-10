//
//  PostJobsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 04/02/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class PostJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblViewJobs: UITableView!
    @IBOutlet weak var btnActiveJobs: UIButton!
    @IBOutlet weak var btnMyPostedJobs: UIButton!
    
    let utils = Utils()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpNavigationStyles()
        
        //set up initial screen view
        initializeScreen()
    }
    
    
    //btnActiveJobsEvent
    @IBAction func btnActiveJobsEvent(_ sender: Any) {
        //set checker
        btnActiveJobsEventRoutine()
    }
    
    //btnMyPostedJobsEvent
    @IBAction func btnMyPostedJobsEvent(_ sender: Any) {
        
        //set checker
        btnMyPostedJobsEventRoutine()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tblJobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempList: clsJobs
        tempList = _tblJobList[indexPath.row]
        let cellPostJobs = Bundle.main.loadNibNamed("TableViewPostJobsCell", owner: self, options: nil)?.first as! TableViewPostJobsCell
        cellPostJobs.lblContactName.text = tempList.sellerName
        cellPostJobs.lblJobName.text = tempList.jobName
        cellPostJobs.lblStartDate.text = tempList.startDate
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy" //"yyyy-MM-dd" //"dd/MM/yyyy"
//        let str = "2017-05-25"
//        let date = dateFormatter.date(from: str)
//        let strDate = dateFormatter.string(from: date!)
//
//        cellPostJobs.lblStartDate.text = strDate //preferred date format dd/MM/yyyy
        
        if indexPath.row % 2 == 0 {
            cellPostJobs.backgroundColor = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0) //UIColor.lightGray
        } else {
            cellPostJobs.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0) //UIColor.gray
        }
        
        return cellPostJobs
    }
    
    /*************  USER DEFINED FUNCTIONS ****************/
    
    //fetch data for display
    private func fetchData(isMyJobs: Bool) {
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                
                var sqlString = ""
                if isMyJobs {
                    //show the jobs posted by the logged in user for both Active and Closed status.
                    print("post all my active and closed jobs")
                    sqlString = "SELECT * FROM tblJobs WHERE jobCreatorType = '" +  String(_currentType) + "' AND jobCreatorUsername = '" + _currentUsername + "' AND status IN (2,5)"
                    
                    print(sqlString)
                } else {
                    //all ACTIVE jobs from all users
                    print("show all active jobs")
                    sqlString = "SELECT * FROM tblJobs WHERE status = 2"
                }
                
                //read from table jobs
                dbController.readFromTableJobs(queryStr: sqlString)
            }
        }
    }
    
    //btnActiveJobs Event Routine
    private func btnActiveJobsEventRoutine() {
        //update colors
        btnActiveJobs.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
        btnMyPostedJobs.backgroundColor = .white
        
        //clear table
        
        
        //fecth data
        fetchData(isMyJobs: false)
        
        //load data to table
        tblViewJobs.reloadData()
    }
    
    //btnMyPostedJobs Event Routine
    private func btnMyPostedJobsEventRoutine() {
        //update color
        btnMyPostedJobs.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
        btnActiveJobs.backgroundColor = .white
        
        //clear table
        
        //fetch data
        fetchData(isMyJobs: true)
        
        //load data to table
        tblViewJobs.reloadData()
    }
    
    //show new screen
    private func showNextScreen( screenName: String ) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //set up screen
    private func initializeScreen() {
        
        //set datasource
        self.tblViewJobs.delegate = self
        self.tblViewJobs.dataSource = self
        
        //fetch initial data - all active jobs
        fetchData(isMyJobs: false)
        
    }
    
    //create new job post
    @objc func createNewJobPostEvent() {
        
        showNextScreen(screenName: "CreateJobPostViewController")
    }
    
    func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Post Jobs"
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createNewJobPostEvent))
    }
}
