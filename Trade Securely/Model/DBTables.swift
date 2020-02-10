//
//  DBTables.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 30/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import Foundation

public var _tblHomeOwner = [ "fName" : "",
                        "lName" : "",
                        "email" : "",
                        "username" : "",
                        "password" : "",
                        "address" : "",
                        "phoneNumber" : "",
                        "mobileNumber" : "",
                        "paymentOptionId": 0 ] as [String : Any]

public var _tblHomeBuilder = [ "fName" : "",
                             "lName" : "",
                             "companyName" : "",
                             "ACN" : "",
                             "email" : "",
                             "username" : "",
                             "password" : "",
                             "phoneNumber" : "",
                             "positionHeld" : "",
                             "address": "" ] as [String : Any]

//var for saving data
public var _tblJobs = [ "projectName" : "",
                    "jobName" : "",
                    "sellerName" : "",
                    "startDate" : "",
                    "endDate" : "",
                    "agreedPrice" : 0,
                    "isProgressBilling" : 0,
                    "paymentOption" : 0,
                    "jobDesc" : "",
                    "jobCreatorType" : 0,
                    "jobCreatorUsername" : "",
                    "status" : 0,
                    "actualStartDate" : "",
                    "actualEndDate" : "",
                    "completionDetails" : "",
                    "deficiencies" : "",
                    "declineComment" : "",
                    "buyerComment" : ""]
                    as [String : Any]

public var _tblPayments = ["jobID" : 0,
                         "paymentNumber" : 0,
                         "amount" : 0] as [String : Any]

public var _tblDisputes = [ "id" : 0,
                            "jobID" : 0,
                            "disputeStatus": 0,
                            "natureOfDispute" : "",
                            "description" : "",
                            "proposedResolution" : ""] as [String : Any]

public var _tblVariations = [ "id" : 0,
                              "jobID" : 0,
                              "variationStatus": 0,
                              "natureOfVariation" : "",
                              "description" : "",
                              "cost" : 0] as [String : Any]

public var _tblPostedJobs = [ "id" : 0,
                            "contactName" : "",
                            "jobName" : "",
                            "phone" : "",
                            "email" : "",
                            "preferredStartDate" : "",
                            "jobDesc" : "",
                            "status" : 0] as [String : Any]


//data placeholder
public var _currentType: Int = 0  //1-HomeOwner, 2-HomeBuilder
public var _currentUsername: String = ""
public var _currentFName:String = ""
public var _currentLName:String = ""
public var _username: String = ""
public var _fname: String = ""
public var _lname: String = ""
public var _email: String = ""
public var _password: String = ""

public class clsHomeOwner {
    var id:Int
    var fName: String
    var lName: String
    var email: String
    var username: String
    var password: String
    var address: String
    var phoneNumber: String
    var mobileNumber: String
    var paymentOptionId: Int
    
    init(id: Int, fName: String, lName: String, email: String, username: String, password: String, address: String, phoneNumber: String, mobileNumber: String, paymentOptionId: Int) {
        self.id = id
        self.fName = fName
        self.lName = lName
        self.email = email
        self.username = username
        self.password = password
        self.address = address
        self.phoneNumber = phoneNumber
        self.mobileNumber = mobileNumber
        self.paymentOptionId = paymentOptionId
    }
    
    func getInitials()->String {
        let initials = String(fName.prefix(1)) + String(lName.prefix(1))
        return initials
    }
}
public var _tblCurrentHomeOwnerData = [clsHomeOwner]()

public class clsHomeBuilder {
    var id: Int
    var fName: String
    var lName: String
    var companyName: String
    var ACN: String
    var email: String
    var phoneNumber: String
    var mobileNumber: String
    var username: String
    var password: String
    var positionHeld: String
    var address: String
    
    init(id:Int, fName: String, lName: String, companyName: String, ACN: String, email: String, phoneNumber: String, mobileNumber: String, username: String, password: String, positionHeld: String, address: String) {
        self.id = id
        self.fName = fName
        self.lName = lName
        self.companyName = companyName
        self.ACN = ACN
        self.email = email
        self.phoneNumber = phoneNumber
        self.mobileNumber = mobileNumber
        self.positionHeld = positionHeld
        self.address = address
        self.username = username
        self.password = password
    }
    
    func getInitials()->String {
        let initials = String(fName.prefix(1)) + String(lName.prefix(1))
        return initials
    }
}
public var _tblCurrentHomeBuilderData = [clsHomeBuilder]()

public class clsJobs {
    var id:Int
    var projectName: String
    var jobName: String
    var sellerName: String
    var startDate: String
    var endDate: String
    var agreedPrice: Int
    var isProgressBilling: Int
    var paymentOption: Int
    var jobDesc: String
    var jobCreatorType: Int
    var jobCreatorUsername: String
    var status: Int
    var actualStartDate: String
    var actualEndDate: String
    var completionDetails: String
    var deficiencies: String
    var declineComment: String
    var buyerComment : String
    
    init(id: Int, projectName: String, jobName: String, sellerName: String, startDate: String, endDate: String, agreedPrice: Int, isProgressBilling: Int, paymentOption: Int, jobDesc: String, jobCreatorType: Int, jobCreatorUsername: String, status: Int, actualStartDate: String, actualEndDate: String, completionDetails: String, deficiencies: String, declineComment: String, buyerComment : String) {
        
        self.id = id
        self.projectName = projectName
        self.jobName = jobName
        self.sellerName = sellerName
        self.startDate = startDate
        self.endDate = endDate
        self.agreedPrice = agreedPrice
        self.isProgressBilling = isProgressBilling
        self.paymentOption = paymentOption
        self.jobDesc = jobDesc
        self.jobCreatorType = jobCreatorType
        self.jobCreatorUsername = jobCreatorUsername
        self.status = status
        self.actualStartDate = actualStartDate
        self.actualEndDate = actualEndDate
        self.completionDetails = completionDetails
        self.deficiencies = deficiencies
        self.declineComment = declineComment
        self.buyerComment = buyerComment
    }
}

public var _tblJobList = [clsJobs]()
public var _tblCurrentJobData = [clsJobs]()

//payment class
public class clsPayments {
    var id: Int
    var jobID: Int
    var paymentNumber: Int
    var amount: Int
    
    init(id:Int, jobID: Int, paymentNumber: Int, amount: Int) {
        self.id = id
        self.jobID = jobID
        self.paymentNumber = paymentNumber
        self.amount = amount
    }
}
public var _tblPaymentList = [clsPayments]()

public class clsDisputes {
    var id: Int
    var jobID: Int
    var disputeStatus: Int
    var natureOfDispute: String
    var description: String
    var proposedResolution: String

    init(id: Int, jobID: Int, disputeStatus: Int, natureOfDispute: String, description: String, proposedResolution: String) {
        self.id = id
        self.jobID = jobID
        self.disputeStatus = disputeStatus
        self.natureOfDispute = natureOfDispute
        self.description = description
        self.proposedResolution = proposedResolution
    }
}
public var _tblDisputeList = [clsDisputes]()

public class clsVariations {
    var id: Int
    var jobID: Int
    var variationStatus: Int
    var natureOfVariation: String
    var description: String
    var cost: Int
    
    init(id: Int, jobID: Int, variationStatus: Int, natureOfVariation: String, description: String, cost: Int) {
        self.id = id
        self.jobID = jobID
        self.variationStatus = variationStatus
        self.natureOfVariation = natureOfVariation
        self.description = description
        self.cost = cost
    }
}
public var _tblVariationList = [clsVariations]()

//job post
public class clsPostedJobs {
    var id: Int
    var contactName: String
    var jobName: String
    var phone: String
    var email: String
    var preferredStartDate: String
    var jobDesc: String
    var status: Int
    
    init(id: Int, jobID: Int,contactName: String, jobName: String, phone: String, email: String, preferredStartDate: String, jobDesc: String, status: Int) {
        self.id = id
        self.contactName = contactName
        self.jobName = jobName
        self.phone = phone
        self.email = email
        self.preferredStartDate = preferredStartDate
        self.jobDesc = jobDesc
        self.status = status
    }
}
public var _tblPostedJobList = [clsPostedJobs]()

class clsTempTable {
    var id: Int
    var tempName: String
    var tempDetails: String
    
    init(id:Int, tempName:String, tempDetails:String) {
        self.id = id
        self.tempName = tempName
        self.tempDetails = tempDetails
    }
}

//struct for display
struct VariationsPerJob {
    var jobID : Int
    var jobName : String
    var variationID : Int
    var variationNature : String
}

struct DisputesPerJob {
    var jobID : Int
    var jobName : String
    var variationID : Int
    var variationNature : String
}


