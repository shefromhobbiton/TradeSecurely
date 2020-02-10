//
//  CreateJobViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 17/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class CreateJobViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var jobID: Int = 0
    
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnAcceptJob: UIButton!
    @IBOutlet weak var btnDeclineJob: UIButton!
    @IBOutlet weak var btnJobComplete: UIButton!
    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var txtJobName: UITextField!
    @IBOutlet weak var txtSeller: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtAgreedPrice: UITextField!
    @IBOutlet weak var txtJobDesc: UITextView!
    @IBOutlet weak var txtDeclineComment: UITextView!
    @IBOutlet weak var txtBuyerComments: UITextView!
    @IBOutlet weak var tblViewPayment: UITableView!
    @IBOutlet weak var btnAddNewPayment: UIButton!
    @IBOutlet weak var viewPaymentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtFieldStatus: UITextField!
    @IBOutlet weak var txtFieldJobID: UITextField!
    @IBOutlet weak var viewContainerJobID: UIView!
    @IBOutlet weak var viewContainerStatus: UIView!
    @IBOutlet weak var viewContainerBtnContinue: UIView!
    @IBOutlet weak var viewContainerBtnAcceptJob: UIView!
    @IBOutlet weak var viewContainerBtnDeclineJob: UIView!
    @IBOutlet weak var viewContainerJobComplete: UIView!
    @IBOutlet weak var viewContainerDeclineComments: UIView!
    @IBOutlet weak var viewContainerBuyerComments: UIView!
    @IBOutlet weak var viewSidePanelBG: UIView!
    @IBOutlet weak var viewSidePanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgViewSidePanelLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewSidePanelTransparentLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewSidePanelTransparent: UIView!
    @IBOutlet weak var txtDisplayName: UIButton!
    
    //side panel menu
    @IBOutlet weak var btnAddViewDispute: UIButton!
    @IBOutlet weak var btnAddViewVariation: UIButton!
    
    let utils = Utils()
    let dbController = DBController()
    let datePicker = UIDatePicker()
    var rowIndex = 0
    var whichData = 0 // 1-start date, 2-end date
    var showMenu = true
    var isBackPressed = true  //for hiding menu on back button pressed
    var tempAgreedPrice = 0  //temporary storage for price
    
    //TEMP
    var tempArray = [[1,0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation styles
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //TEMP
        initializeScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set checker
        isBackPressed = true
        
        //don't show menu
        if globals.currentAction != 0 {
            //set up slider view (menu)
            setUpSliderView()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if isBackPressed {
            viewSidePanelBG.isHidden = true
            viewSidePanelTransparent.isHidden = true
        }
    }
    
    //didEditingEnd
    @IBAction func txtFldPrice(_ sender: UITextField) {
        
        tempAgreedPrice = Int(sender.text!) ?? 0
        
        //set thousands separator on amount
        if txtAgreedPrice.text?.count ?? 0 > 3 {
            txtAgreedPrice.text = utils.formatNumber(numValue: Int(txtAgreedPrice.text!)!)
        }
    }
    
    @IBAction func btnYes(_ sender: Any) {
        if btnYes.isSelected == false {
            btnYes.isSelected = true
            btnNo.isSelected = false
            
            //enable add payment
            btnAddNewPayment.isEnabled = true
            
            //set progress billing
             _tblJobs["isProgressBilling"] = 1
        }
    }
    
    @IBAction func btnNo(_ sender: Any) {
        if btnNo.isSelected == false {
            btnNo.isSelected = true
            btnYes.isSelected = false
            
            //set answer
            _tblJobs["isProgressBilling"] = 0
            
            //enable add payment
            btnAddNewPayment.isEnabled = false
        }
    }
    
    @IBAction func btnAddNewPayment(_ sender: Any) {
        
        //add new row to table
        addNewRowToTable()
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        btnContinueRoutine()
    }
    
    @IBAction func btnAcceptJob(_ sender: Any) {
        
        btnAcceptJobRoutine()
    }
    
    @IBAction func btnDeclineJob(_ sender: Any) {
        
    }
    
    @IBAction func btnJobComplete(_ sender: Any) {
        
        
        //job completion routine
        btnCompleteJobRoutine()
        
    }
    
    @IBAction func txtfldStartdate(_ sender: Any) {
        whichData = 1
    }
    
    @IBAction func txtfldEndDate(_ sender: Any) {
        whichData = 2
    }

    //detect touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.viewSidePanelTransparent {
                
                showHideMenu()
            } else {
                
            }
        }
    }
    
    //set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    //populate table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //add row
        let cellPayment = tableView.dequeueReusableCell(withIdentifier: "TableViewAddPaymentCell") as! TableViewAddPaymentCell
        cellPayment.lblPaymentNo.text = String(tempArray[indexPath.row][0])
        
        if globals.currentAction > 0 { // search or open
            cellPayment.txtfldPayment.text = String(tempArray[indexPath.row][1])
            //set thousands separator on amount
            if cellPayment.txtfldPayment.text?.count ?? 0 > 3 {
                cellPayment.txtfldPayment.text = utils.formatNumber(numValue: Int(cellPayment.txtfldPayment.text!)!)
            }
            cellPayment.btnDeletePayment.isHidden = true
        } else { // add job
            cellPayment.txtfldPayment.text = ""
        }
        
        cellPayment.selectionStyle = .none
        cellPayment.btnDeletePayment.tag = indexPath.row
        cellPayment.btnDeletePayment.addTarget(self, action: #selector(deleteRowFromTable(sender:)), for: .touchUpInside)
        cellPayment.txtfldPayment.tag = indexPath.row
        cellPayment.txtfldPayment.addTarget(self, action: #selector(getDataFromTable(sender:)), for: .editingDidEnd)
        return cellPayment
    }
    
    //****************** SIDE PANEL EVENT ********************/
    @IBAction func btnAddViewDispute(_ sender: Any) {
        
        //set checker
        isBackPressed = false
        disputeEventRoutine()
    }
    
    @IBAction func btnAddViewVariation(_ sender: Any) {
        //set checker
        isBackPressed = false
        variationEventRoutine()
    }
    
    /******************* USER DEFINED FUNCTIONS *******************/
    
    //*********** EVENT HANDLERS ***********//
    @objc func doneButton(){
        //start date
        if whichData == 1 {
            if let datePicker = self.txtStartDate.inputView as? UIDatePicker {
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .long
                self.txtStartDate.text = dateformatter.string(from: datePicker.date)
                
            }
            self.txtStartDate.resignFirstResponder()
        }
        
        //end date
        if whichData == 2 {
            if let datePicker = self.txtEndDate.inputView as? UIDatePicker {
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = .long
                
                self.txtEndDate.text = dateformatter.string(from: datePicker.date)
            }
            self.txtEndDate.resignFirstResponder()
        }
    }
    
    @objc func getDataFromTable(sender: UITextField) {
        
        //NOTE: tag refers to row index
        //insert user input to array
        if (sender.text?.count)! > 0 {
            tempArray[sender.tag][1] = Int(sender.text!)!
        }
        
        //set thousands separator on amount
        if sender.text?.count ?? 0 > 3 {
            sender.text = utils.formatNumber(numValue: Int(sender.text!)!)
        }
    }
    
    //delete row
    @objc func deleteRowFromTable(sender: UIButton) {
        
        let ctr = tempArray[tempArray.count - 1][0] - 1
        
        if ctr >= 2 {
            
            //delete row
            self.tempArray.remove(at: sender.tag)
            
            //update payment number on array
            for ctr in 0...tempArray.count-1 {
                tempArray[ctr][0] = ctr + 1
            }
            
            //reload table data
            tblViewPayment.reloadData()
            
            //adjust height constraint
            viewPaymentHeightConstraint.constant = viewPaymentHeightConstraint.constant - 90
        } else {
            let alert = utils.showOKAlert(title: "Minimum Payment Schedule", message: "A minimum of 2 payments should be scheduled.")
            present(alert, animated: true)
        }
    }
    
    //show menu
    @objc func btnMenuEvent() {
        showHideMenu()
    }
    
    //add/new dispute event handler
    func disputeEventRoutine() {
        
        //hide menu
        showHideMenu()
        
        //show next screen
        showNextScreen(screenName: "DisputeListViewController")
    }
    
    //add/new variation event handler
    func variationEventRoutine() {
        
        //hide menu
        showHideMenu()
        
        //show next screen
        showNextScreen(screenName: "VariationListViewController")
    }
    
    // show/hide side menu panel
    func showHideMenu() {
        
        if showMenu {
            bgViewSidePanelLeadingConstraints.constant = 0
            viewSidePanelTransparentLeadingConstraints.constant = 0
            viewSidePanelBG.isHidden = false
            viewSidePanelTransparent.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            bgViewSidePanelLeadingConstraints.constant = -300
            viewSidePanelTransparentLeadingConstraints.constant = -375
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion:  { (value: Bool) in
                self.viewSidePanelBG.isHidden = true
                self.viewSidePanelTransparent .isHidden = true
            })
        }
        showMenu = !showMenu
    }

    //set up side menu panel
    func setUpSliderView() {
        
        //set up side panel/slider view
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let statBarHeight = utils.getStatusBarHeight()
        viewSidePanelHeightConstraint.constant = screenHeight - navHeight! - statBarHeight
        
        //set display name
        let displayName = String(_currentFName.prefix(1)) + String(_currentLName.prefix(1))
        txtDisplayName.setTitle(displayName, for: .normal)

        //make slider view visible
        bgViewSidePanelLeadingConstraints.constant = -300
        viewSidePanelBG.isHidden = false

        //hide bgSlider
        viewSidePanelTransparentLeadingConstraints.constant = -375
        viewSidePanelTransparent.isHidden = false
    }
    
    //set up date input fields
    func setUpDateInputTextFields() {
        
        //set date picker as keyboard
        txtStartDate.setInputViewDatePicker(target: self, selector: #selector(doneButton))
        txtEndDate.setInputViewDatePicker(target: self, selector: #selector(doneButton))
    }
    
    //copy user inputs
    func getDataFromTextField()->Bool {
        
        if txtProjectName.text!.count > 0 {
            _tblJobs["projectName"] = txtProjectName.text
        } else {
            return false
        }
        
        if txtJobName.text!.count > 0 {
            _tblJobs["jobName"] = txtJobName.text
        } else {
            return false
        }
        
        if txtSeller.text!.count > 0 {
            _tblJobs["sellerName"] = txtSeller.text
        } else {
            return false
        }
        
        if txtStartDate.text!.count > 0 {
            _tblJobs["startDate"] = txtStartDate.text
        } else {
            return false
        }
        
        if txtEndDate.text!.count > 0 {
            _tblJobs["endDate"] = txtEndDate.text
        } else {
            return false
        }
        
        if txtAgreedPrice.text!.count > 0 {
            _tblJobs["agreedPrice"] = tempAgreedPrice //Int(txtAgreedPrice.text!)
        } else {
            return false
        }
            
        if txtJobDesc.text!.count > 0 {
            _tblJobs["jobDesc"] = txtJobDesc.text
        } else {
            return false
        }

        //TEMP:
        _tblJobs["paymentOption"] = 0  //remove this field on the next build
        _tblJobs["jobCreatorType"] = _currentType
        _tblJobs["jobCreatorUsername"] = _currentUsername
        _tblJobs["status"] = 1 //pending
        _tblJobs["actualStartDate"] = ""
        _tblJobs["actualEndDate"] = ""
        _tblJobs["completionDetails"] = ""
        _tblJobs["deficiencies"] = ""
        _tblJobs["declineComment"] = ""
        _tblJobs["buyerComment"] = ""
        
        //get jobID
        let dbController = DBController()
        var tempJobID = 0
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                tempJobID = dbController.getLastJobID() + 1
            }
        }
        
        //copy payment details
        _tblPaymentList.removeAll()  //initialize container
        for ctr in 0...tempArray.count - 1 {
            _tblPaymentList.append(clsPayments(id: 0, jobID: tempJobID, paymentNumber: tempArray[ctr][0], amount: tempArray[ctr][1]))
        }

        return true
    }
    
    
    //add new row to table view
    func addNewRowToTable() {
        
        let ctr = tempArray[tempArray.count - 1][0] + 1
        
        if ctr < 5 {
            //increase UIViewPayment's height
            viewPaymentHeightConstraint.constant = viewPaymentHeightConstraint.constant + 90
            
            //insert new row to array
            //increase payment no.
            tempArray.append([ctr, 0])
        
            tblViewPayment.beginUpdates()
            let indexPath:IndexPath = IndexPath(row:(self.tempArray.count - 1), section:0)
            tblViewPayment.insertRows(at: [indexPath], with: .left)
            tblViewPayment.endUpdates()
        } else {
            let alert = utils.showOKAlert(title: "Maximum Payment Schedule Reached", message: "A maximum of 5 payments can be scheduled.")
            present(alert, animated: true)
        }
    }
    
    
    
    //display current job data
    private func disableEditableFields() {
        
        //disable editing on textfields
        
        //id
        txtFieldJobID.isUserInteractionEnabled = false
        
        //status
        txtFieldStatus.isUserInteractionEnabled = false
        
        //job name
        txtJobName.isUserInteractionEnabled = false
        
        //project name
        txtProjectName.isUserInteractionEnabled = false
        
        //buyer username
        txtSeller.isUserInteractionEnabled = false
        
        //start date
        txtStartDate.isUserInteractionEnabled = false
        
        //end date
        txtEndDate.isUserInteractionEnabled = false
        
        //agree price
        txtAgreedPrice.isUserInteractionEnabled = false
        
        //disable buttons
        if btnNo.isSelected {
            btnYes.isEnabled = false
        } else {
            btnNo.isEnabled = false
        }
        
        //hide add payment button
        btnAddNewPayment.isHidden = true
        
        //job desc
        txtJobDesc.isUserInteractionEnabled = false
        
        //decline comment
        txtDeclineComment.isUserInteractionEnabled = false
        
        //disable editing on payment table
        tblViewPayment.isUserInteractionEnabled = false
    }
    
    private func setDataOnTextFields() {
        
        //id
        txtFieldJobID.text = String(globals.currentJobID)
        
        //status
        txtFieldStatus.text = globals.currentJobStatus
        
        //job name
        txtJobName.text = _tblCurrentJobData[0].jobName
        
        //project name
        txtProjectName.text = _tblCurrentJobData[0].projectName
        
        //buyer username
        txtSeller.text = _tblCurrentJobData[0].jobCreatorUsername
        
        //start date
        txtStartDate.text = _tblCurrentJobData[0].startDate
        
        //end date
        txtEndDate.text = _tblCurrentJobData[0].endDate
        
        //agree price
        txtAgreedPrice.text = String(_tblCurrentJobData[0].agreedPrice)
        //set thousands separator on amount
        if txtAgreedPrice.text?.count ?? 0 > 3 {
            txtAgreedPrice.text = utils.formatNumber(numValue: Int(txtAgreedPrice.text!)!)
        }
        
        //progress billing (button)
        if _tblCurrentJobData[0].isProgressBilling == 1 {
            btnYes.isSelected = true
        } else {
            btnNo.isSelected = true
        }
        
        //payment (tableview)
        tempArray.removeAll()
        if _tblPaymentList.count == 1 {
            tempArray.append([_tblPaymentList[0].paymentNumber, _tblPaymentList[0].amount])
        } else {
            for ctr in 0..._tblPaymentList.count-1 {
                //add row
                //increase UIViewPayment's height
                if ctr > 0 {
                    viewPaymentHeightConstraint.constant = viewPaymentHeightConstraint.constant + 90
                }
                
                //insert new row to array
                //increase payment no.
                tempArray.append([_tblPaymentList[ctr].paymentNumber, _tblPaymentList[ctr].amount])
                
                tblViewPayment.beginUpdates()
                let indexPath:IndexPath = IndexPath(row:(self.tempArray.count - 1), section:0)
                tblViewPayment.insertRows(at: [indexPath], with: .left)
                tblViewPayment.endUpdates()
            }
        }
        //job desc
        txtJobDesc.text = _tblCurrentJobData[0].jobDesc
        
        if globals.currentJobStatusID == 4 {
            viewContainerDeclineComments.isHidden = false
            txtDeclineComment.text = _tblCurrentJobData[0].declineComment
        }
    }
    
    //btnAcceptJob Routine
    private func btnAcceptJobRoutine() {
        
        //show signature screen
        showNextScreen(screenName: "CreateJobSignatureViewController")
    }
    
    //btnAcceptJob Routine
    private func btnDeclineJobRoutine() {
        
    }
    
    //btnCompleteJobRoutine
    private func btnCompleteJobRoutine() {
        
        //set navigation title
        globals.screenName = "Completion Report"
        
        //show Completion Report Screen
        showNextScreen(screenName: "CompletionReportViewController")
    }
    
    //btnContinue routine
    private func btnContinueRoutine(){
        //copy user input
        if getDataFromTextField() {
            //show next screen
            showNextScreen(screenName: "CreateJobSignatureViewController")
        } else {
            //alert incomplete details
            let alert = utils.showOKAlert(title: "Incomplete Details", message: "Please fill up all the required information")
            present(alert, animated: true)
        }
    }
    
    //enable disable buttons
    private func enableDisableButtons() {
        
        //continue, accept job, decline job, job complete
        // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed", 6 - "Pending Payment"
        if globals.currentAction == 0 { //from main screen (create jobs)
            viewContainerBtnAcceptJob.isHidden = true
            viewContainerBtnDeclineJob.isHidden = true
            viewContainerJobComplete.isHidden = true
        } else if globals.currentAction == 1 {
            //view from search jobs screen- hide all buttons
            viewContainerBtnContinue.isHidden = true
            viewContainerBtnAcceptJob.isHidden = true
            viewContainerBtnDeclineJob.isHidden = true
            viewContainerJobComplete.isHidden = true
        } else {
            //view from open jobs screen
            if globals.currentJobStatusID == 1 { //"Pending"
                viewContainerBtnContinue.isHidden = true
                viewContainerJobComplete.isHidden = true
            } else if globals.currentJobStatusID == 2 { //"Active"
                viewContainerBtnContinue.isHidden = true
                viewContainerBtnAcceptJob.isHidden = true
                viewContainerBtnDeclineJob.isHidden = true
            } else if globals.currentJobStatusID == 3 { //"Completed"
                viewContainerBtnContinue.isHidden = true
                viewContainerBtnAcceptJob.isHidden = true
                viewContainerBtnDeclineJob.isHidden = true
            }
        }
        
    }
    
    //show new screen
    private func showNextScreen( screenName: String ) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //initialize screeen
    private func initializeScreen() {
        //set up navigation style
        setUpNavigationStyles()
        
        
        //TEMP:
        //txtAgreedPrice.leftView.te = "$"
        
        //register nib
        //register tableview cells
        tblViewPayment.register(UINib.init(nibName:"TableViewAddPaymentCell", bundle: nil), forCellReuseIdentifier: "TableViewAddPaymentCell")
        
        //set up table view
        tblViewPayment.dataSource = self
        tblViewPayment.delegate = self
        
        if globals.currentAction == 0 { //new job
            
            //set up date input fields
            setUpDateInputTextFields()
            
            //set progress billing to true
            btnYes.isSelected = true
            
            //set add payment button to true
            btnAddNewPayment.isEnabled = true
            
            //set up buttons
            enableDisableButtons()
            
            _tblJobs["isProgressBilling"] = 1  //default to YES
        } else {  //from table list
            //clear tableview
            tempArray.removeAll()
            tblViewPayment.reloadData()
            
            //populate list
            let dbController = DBController()
            dbController.fetchCurrentJobData()
            dbController.fetchCurrentPaymentsData()
            
            //show details for the selected job ID
            viewContainerJobID.isHidden = false
            viewContainerStatus.isHidden = false
            
            //set data
            setDataOnTextFields()
            
            //disable editable fields
            disableEditableFields()
            
            //set up buttons
            enableDisableButtons()
        }
    }
    
    //set up navigation bar
    func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = globals.screenName
        self.navigationItem.backBarButtonItem?.title = " "
        
        //check status and show menu if needed
        //show menu when status is 1 - Active or 3 - Completed
        if globals.currentJobStatusID == 2 || globals.currentJobStatusID == 3 {
            //add menu button
            let rightBarButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            rightBarButtonItem.setImage(UIImage(named: "btnJobDetailsMenu"), for: .normal)
            rightBarButtonItem.addTarget(self, action: #selector(btnMenuEvent), for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: rightBarButtonItem)
            NSLayoutConstraint.activate([(barButton.customView!.widthAnchor.constraint(equalToConstant: 30)),(barButton.customView!.heightAnchor.constraint(equalToConstant: 20))])
            self.navigationItem.rightBarButtonItem  = barButton
        }
    }
}
