//
//  HelpfulHintsViewController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 10/01/2020.
//  Copyright © 2020 Travezl. All rights reserved.
//

import UIKit

class HelpfulHintsViewController: UIViewController {

    @IBOutlet weak var txtFieldHints: UITextView!
    @IBOutlet weak var btnRaiseDispute: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationStyles()
    }
    
    @IBAction func btnRaiseDispute(_ sender: Any) {
        //show Dispute List Screen
        showNextScreen(screenName: "DisputeListViewController")
    }
    
    @IBAction func btnClose(_ sender: Any) {
        //show Variation List Screen
        showNextScreen(screenName: "VariationListViewController")
    }
    
    
    //*********************** USER DEFINED FUNCTIONS ***************************//
    private func setUpNavigationStyles() {
        let bgColor = utils.hexStringToUIColor(hex: "#373637")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationItem.title = "Job Payment"
        self.navigationItem.backBarButtonItem?.title = " "
    }
    
    //show next screen
    private func  showNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //move to next screen
    private func  moveToNextScreen(screenName: String){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName)
        self.navigationController!.popToViewController(viewController, animated: true)
        //self.present(viewController, animated: true, completion: nil)
    
    }
    
    private func initializeScreen() {
        
        
       
    }

}
