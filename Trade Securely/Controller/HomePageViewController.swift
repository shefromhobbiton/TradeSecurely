//
//  HomePageViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 11/10/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    var showMenu = true
    
    //constraints
    @IBOutlet weak var sliderViewLeading: NSLayoutConstraint!
    @IBOutlet weak var bgSliderLeading: NSLayoutConstraint!
    
    @IBOutlet weak var bgSliderView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var txtDisplayName: UIButton!  // uibutton used for display name
    @IBOutlet weak var bgView: UIView!
    
    //Slider View Outllets
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnDisputes: UIButton!
    @IBOutlet weak var btnVariations: UIButton!
    @IBOutlet weak var btnMyWallet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide navigation bar
        self.setUpNavBar()
        
        //popupate user account table
        populateUserAccountTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //navigationController?.isNavigationBarHidden = true
        
        //set up slider view (menu)
        setUpSliderView()
        
        //initialize variables
        initializeGlobalVariables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        showHideMenu()
    }
    
    @IBAction func btnCreateNewJob(_ sender: Any) {
        //set global var
        globals.isEdit = false
        
        //set screen name
        globals.screenName = "Create Job"
        
        //show next screen
        showNextScreen(screenName: "CreateJobViewController")
    }
    
    @IBAction func btnSearchJobs(_ sender: Any) {
        showNextScreen(screenName: "SearchJobsViewController")
    }
    
    @IBAction func btnOpenJobs(_ sender: Any) {
        //set variable to check which calls the job list screen
        globals.isFromHomeMenu = false
        showNextScreen(screenName: "OpenJobsViewController")
    }
    
    @IBAction func btnPostJobs(_ sender: Any) {
        
        showNextScreen(screenName: "PostJobsViewController")
    }
    
    //*********** Slider view Events ***********// - START -
    @IBAction func btnMyWallet(_ sender: Any) {
        
        //hide menu
        showHideMenu()
        
        //show My Wallet Screen
        showNextScreen(screenName: "MyWalletViewController")
    }
    
    //view profile
    @IBAction func btnViewProfile(_ sender: Any) {
        
        //hide menu
        showHideMenu()
        
        //show next screen
        showNextScreen(screenName: "AccountDetailsViewController")
    }
    
    @IBAction func btnAddViewDisputes(_ sender: Any) {
        //hide menu
        showHideMenu()
        
        //set variable to check which calls the job list screen
        globals.isFromHomeMenu = true

        //set which list to display
        globals.whichList = 1
        
        //show job list
        showNextScreen(screenName: "OpenJobsViewController")
    }
    
    @IBAction func btnAddViewVariations(_ sender: Any) {
        
        //hide menu
        showHideMenu()
        
        
        //set variable to check which calls the job list screen
        globals.isFromHomeMenu = true
        
        //set which list to display
        globals.whichList = 2
        
        //show job list
        showNextScreen(screenName: "OpenJobsViewController")
    }
    
    //log out user
    @IBAction func btnLogOut(_ sender: Any) {
        
        logOutRoutine()
    }
    
    //*********** Slider view Events ***********// - END
    
    //detect touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.bgView {
                print("touched bgView")
                showHideMenu()
            } else {
                print("else")
            }
        }
    }
    
    /********************** USER DEFINED FUNCTIONS *************************/
    private func logOutRoutine() {
        
        //dissmiss all views
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
        //load LogInNavigationController
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInNavigationController")
        self.present(navigationController, animated: true, completion: nil)
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
//        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    private func setUpNavBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor .orange
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    // show/hide side menu panel
    func showHideMenu() {
        if showMenu {
            sliderViewLeading.constant = 0
            bgSliderLeading.constant = 0
            sliderView.isHidden = false
            bgSliderView.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            sliderViewLeading.constant = -300
            bgSliderLeading.constant = -375
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion:  { (value: Bool) in
                    self.sliderView.isHidden = true
                    self.bgSliderView.isHidden = true
            })
        }
        showMenu = !showMenu
    }

    //set up side menu panel
    func setUpSliderView() {
        
        //set display name
        let displayName = String(_currentFName.prefix(1)) + String(_currentLName.prefix(1))
        txtDisplayName.setTitle(displayName, for: .normal)
        
        //make slider view visible
        sliderViewLeading.constant = -300
        sliderView.isHidden = false
        
        //hide bgSlider
        bgSliderLeading.constant = -375
        bgSliderView.isHidden = false
    }
    
    //check for user table, populate if empty
    private func populateUserAccountTable() {
        let dbController = DBController()
        if dbController.openDatabaseFile() == true {
            if dbController.createTable() == true {
                var sqlStr = ""
                if _currentType == 1 {
                    sqlStr = "SELECT * FROM tblHomeOwner WHERE username = '" + _currentUsername + "'"
                    _ = dbController.readFromTableHomeOwner(queryStr: sqlStr)
                } else {
                    sqlStr = "SELECT * FROM tblHomeBuilder WHERE username = '" + _currentUsername + "'"
                    _ = dbController.readFromTableHomeBuilder(queryStr: sqlStr)
                }
            }
        } else {
            print("DB creation failed")
        }
        
    }
    
    //intialize global variables
    func initializeGlobalVariables() {
        globals.isEdit = false
        globals.currentAction = 0  //1 - search, 2 - open jobs
        globals.currentJobID = 0
        globals.currentJobStatus = "" // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed"
        globals.currentJobStatusID = 0
        globals.screenName = ""
        globals.navTitle = ""  //title of the screen when navigating
    }
    
    //show new screen
    private func showNextScreen( screenName: String ) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
