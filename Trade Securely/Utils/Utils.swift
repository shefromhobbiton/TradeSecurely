//
//  Utils.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 27/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import UIKit

struct globals {
    static var isEdit: Bool = false
    static var currentAction: Int = 0  //1 - search, 2 - open jobs
    static var currentJobID: Int = 0
    static var currentJobStatus: String = "" // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed", 6 - "Pending Payment"
    static var currentJobStatusID: Int = 0
    static var currentJobName: String = ""
    static var screenName: String = ""
    static var navTitle: String = ""  //title of the screen when navigating
    
    //disputes
    static var currentDisputeID = 0
    static var currentDisputeStatus = 0 // 1 - "Draft", 2 - "Pending", 3 - "Active", 4 - "Resolved"
    
    //variations
    //static var currentVariationID = 0
    //static var currentVariationStatus = 0 // 1 - "Draft", 2 - "Pending", 3 - "Active", 4 - "Approved", 5 - "Rejected"
    
    //main menu
    static var whichList: Int = 0 //1 - Dispute, 2 - Variation
    static var isFromHomeMenu: Bool = false  //true - if opening job list from home menu items, false - if opening job list from home buttons
}

@IBDesignable class BottomAlignedLabel: UILabel {
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        
        guard text != nil else {
            return super.drawText(in: rect)
        }
        
        let height = self.sizeThatFits(rect.size).height
        let y = rect.origin.y + rect.height - height
        super.drawText(in: CGRect(x: 0, y: y - 10, width: rect.width, height: height))
    }
}

//custom UIButton design
@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

//custom UITextField design
@IBDesignable extension UITextField {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
}




class Utils: NSObject {
    
    //convert string to hex value
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //alert helper
    func showOKAlert(title: String, message: String)->UIAlertController {
        //show alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        return alert
    }
    
    //get current status bar height
    func getStatusBarHeight()->CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    //set up globals for next screen
    //set jobID for viewing
    func setRequiredGlobals(jobID: Int, jobStatus: Int, currentAction: Int) {
        let dbController = DBController()
        
        //set current job id
        globals.currentJobID = jobID
        
        //set current job status
        globals.currentJobStatus = dbController.getJobStatus(status: jobStatus)
        globals.currentJobStatusID = jobStatus
        
        //set switch for editing
        if currentAction == 1 {
            
            //set globals
            globals.currentAction = 1 //search
            
            //set screen name
            globals.screenName = "Review Job Details"
        } else {
            
            // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed"
            
            //set globals
            globals.currentAction = 2 //search
            
            if jobStatus == 1 {  //if "Pending"
                globals.screenName = "Review Job Details"
            } else if jobStatus == 2 { // "Active"
                globals.screenName = "Job Details"
            }
            
        }
    }
    
    //add thousands separator
    func formatNumber(numValue: Int )->String {
        
        //let largeNumber = 31908551587
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:numValue))
        return formattedNumber!
    }
}


