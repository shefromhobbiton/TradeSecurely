//
//  VariationDisputeTableViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 16/01/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class VariationDisputeTableViewController: UITableViewController {

    let utils = Utils()
    let dbController = DBController()
    var curJobID = 0
    var dataArray = [[Any]]()  //contains data for all sections FORMAT: natureOfVariation+variationID
    var titleArray = [String]()  //contains section headers FORMAT: jobName+jobID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up navigation
        setUpNavigationStyles()
        
        //set up screen
        initializeScreen()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       return dataArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //get number of variations/disputes for the current job in the current section
        return dataArray[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = titleArray[section]
        let titleData = title.components(separatedBy: "+")
        return titleData[0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetails", for: indexPath)
        let lblCell = (dataArray[indexPath.section][indexPath.row] as! String)
        let lblCellArray = lblCell.components(separatedBy: "+")
        cell.textLabel?.text = lblCellArray[0]
        print("variation name -> ", lblCellArray[0])
        print("variation id -> ", lblCellArray[1])
        return cell
    }

    /************************* USER DEFINED FUNCTIONS *******************/
    //fetch data from table
    private func fetchJobData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblJobs WHERE status IN (1,2,3,6) AND jobCreatorUsername = '" + _currentUsername + "'"
                dbController.readFromTableJobs(queryStr: sqlString)
            }
        }
    }
    
    //fetch variation data
    private func fetchVariationData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblVariation WHERE jobID = '" + String(curJobID) + "'"
                dbController.readFromTableVariation(queryStr: sqlString)
            }
        }
    }
    
    //fetch dispute data
    private func fetchDisputeData() {
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                let sqlString = "SELECT * FROM tblDispute WHERE jobID = '" + String(curJobID) + "'"
                dbController.readFromTableDisputes(queryStr: sqlString)
            }
        }
    }
    
    //create and array for table display
    private func setUpVariationArrayForDisplay() {
        
        //get job data
        fetchJobData()
        for ctr in 0..<_tblJobList.count {
            //set current job id
            curJobID = _tblJobList[ctr].id
            
            //get all variation for current job
            fetchVariationData()
            
            var tempArray = [Any]()
            for ctr2 in 0..<_tblVariationList.count {
                tempArray.append(_tblVariationList[ctr2].natureOfVariation + "+" + String(_tblVariationList[ctr2].id))
            }
            
            //add to data array
            dataArray.append(tempArray)
            
            //populate array title
            titleArray.append(_tblJobList[ctr].jobName + "+" + String(_tblJobList[ctr].id))
        }
    }
    
    //create and array for table display
    private func setUpDisputeArrayForDisplay() {
        
        //get job data
        fetchJobData()
        for ctr in 0..<_tblJobList.count {
            //set current job id
            curJobID = _tblJobList[ctr].id
            
            //get all variation for current job
            fetchVariationData()
            
            var tempArray = [Any]()
            for ctr2 in 0..<_tblDisputeList.count {
                tempArray.append(_tblDisputeList[ctr2].natureOfDispute + "+" + String(_tblDisputeList[ctr2].id))
            }
            
            //add to data array
            dataArray.append(tempArray)
            
            //populate array title
            titleArray.append(_tblJobList[ctr].jobName + "+" + String(_tblJobList[ctr].id))
        }
    }
    //set up navigation bar
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Variation List"
        self.navigationItem.backBarButtonItem?.title = "Back"
    }

    //show new screen
    private func showNextScreen( screenName: String ) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //initialize screen
    private func initializeScreen() {
        
        //get all job data for current user
        fetchJobData()
        
        //populate array for display
        //check which list to show
        if globals.whichList == 1 { //disputes
            setUpDisputeArrayForDisplay()
        } else {
            setUpVariationArrayForDisplay()
        }
    }
}
