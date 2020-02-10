//
//  DBController.swift
//  Trade Securely
//
//  Created by She Razon-Bulalaque on 30/09/2019.
//  Copyright © 2019 Travezl. All rights reserved.
//

import Foundation
import SQLite3

class DBController {
    
    var db: OpaquePointer?
    
    //open database file, create it when not db file is not available
    func openDatabaseFile()->Bool {
        
        //create database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("TradeSecurelyDB.sqlite")
        
        //open swift database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return false
        } else {
            print("open db okay")
            return true
        }
    }
    
    //create table
    func createTable()->Bool {
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblTemp (id INTEGER PRIMARY KEY AUTOINCREMENT, tempName TEXT, tempDetails TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }

        //create table tblHomeOwner
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblHomeOwner (id INTEGER PRIMARY KEY AUTOINCREMENT, fName TEXT, lName TEXT, email TEXT,  username TEXT, password TEXT, address TEXT,  phoneNumber TEXT, mobileNumber TEXT, paymentOptionId INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table tblHomeBuilder
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblHomeBuilder (id INTEGER PRIMARY KEY AUTOINCREMENT, fName TEXT, lName TEXT, companyName TEXT, ACN TEXT, email TEXT, phoneNumber TEXT, mobileNumber TEXT, username TEXT, password TEXT, positionHeld TEXT, address TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table jobs
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblJobs (id INTEGER PRIMARY KEY AUTOINCREMENT, projectName TEXT, jobName TEXT, sellerName TEXT, startDate TEXT, endDate TEXT, agreedPrice INTEGER, isProgressBilling INTEGER, paymentOption INTEGER, jobDesc TEXT, jobCreatorType INTEGER, jobCreatorUsername TEXT, status INTEGER, actualStartDate STRING, actualEndDate STRING, completionDetails STRING, deficiencies STRING, declineComment STRING, buyerComment STRING)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table payment
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblPayments (id INTEGER PRIMARY KEY AUTOINCREMENT, jobID INTEGER, paymentNumber INTEGER, amount INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table job completion report
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblCompletionReport (id INTEGER PRIMARY KEY AUTOINCREMENT, jobID INTEGER, actualStartDate TEXT, actualEndDate TEXT, details TEXT, deficiencies TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table status
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblStatus (id INTEGER PRIMARY KEY AUTOINCREMENT, status TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table dispute
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblDispute (id INTEGER PRIMARY KEY AUTOINCREMENT, jobID INT, disputeStatus INT, natureOfDispute TEXT, description STRING, proposedResolution TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        //create table variations
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblVariation (id INTEGER PRIMARY KEY AUTOINCREMENT, jobID INT, variationStatus INT, natureOfVariation TEXT, description STRING, cost INT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
    
        //create table posted jobs
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblPostedJobs (id INTEGER PRIMARY KEY AUTOINCREMENT, contactName TEXT, jobName TEXT, phone TEXT, email TEXT, preferredStartDate TEXT, jobDesc TEXT, status INT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        
        return true
    }
    
    //create tblStatus data
    func createStatusData() {
        
        //creating a statement
        var stmt: OpaquePointer?
        
        /*statuses
         1 - Pending
         2 - Active
         3 - Completed
         4 - Declined
         5 - Closed
        */
        
        let tempStatus = ["Pending", "Active", "Completed", "Declined", "Closed"]
        
        for ctr in 0...4 {
            let queryString = "INSERT INTO tblStatus (status) VALUES (?)"
            
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
            if sqlite3_bind_text(stmt, 1, tempStatus[ctr], -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting record: \(errmsg)")
                return
            }
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
    }
    
    
    //********* save data to table
    func saveTempDataToDB() {
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //TEMP
        let name = "Art"
        let details = "a Husband and a father"
        
        //the insert query
        let queryString = "INSERT INTO tblTemp (tempName, tempDetails) VALUES (?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, details, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        //displaying a success message
        print("Temp data saved successfully")
    }
    
    //********* save HomeOwnerdData to table
    func saveHomeOwnerDataToDB()->Bool {
        
        print(">>>>>>  SAVE HOME OWNER DATA  <<<<<<<<")
        //creating a statement
        var stmt: OpaquePointer?
        
        let fName = _tblHomeOwner["fName"] as! String
        let lName = _tblHomeOwner["lName"] as! String
        let email = _tblHomeOwner["email"] as! String
        let username = _tblHomeOwner["username"] as! String
        let password = _tblHomeOwner["password"] as! String
        let address = _tblHomeOwner["address"] as! String
        let phoneNumber = _tblHomeOwner["phoneNumber"] as! String
        let mobileNumber = _tblHomeOwner["mobileNumber"] as! String
        let paymentOptionId = _tblHomeOwner["paymentOptionId"] as! Int
        
        //the insert query
        let queryString = "INSERT INTO tblHomeOwner (fName, lName, email,  username, password, address,  phoneNumber, mobileNumber, paymentOptionId) VALUES (?,?,?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)

        //binding the parameters
        //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
        if sqlite3_bind_text(stmt, 1, fName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, lName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, email, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, username, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, password, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 6, address, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 7, phoneNumber, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 8, mobileNumber, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 9, Int32(paymentOptionId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        
        //displaying a success message
        print("Home Owner data saved successfully")
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        return true
    }
    
    
    //********* save HomeBuilderdData to table
    func saveHomeBuilderDataToDB()->Bool {
        //creating a statement
        var stmt: OpaquePointer?
        
        let fName = _tblHomeBuilder["fName"] as! String
        let lName = _tblHomeBuilder["lName"] as! String
        let companyName = _tblHomeBuilder["companyName"] as! String
        let ACN = _tblHomeBuilder["ACN"] as! String
        let email = _tblHomeBuilder["email"] as! String
        let phoneNumber = _tblHomeBuilder["phoneNumber"] as! String
        let mobileNumber = _tblHomeBuilder["mobileNumber"] as! String
        let username = _tblHomeBuilder["username"] as! String
        let password = _tblHomeBuilder["password"] as! String
        let positionHeld = _tblHomeBuilder["positionHeld"] as! String
        let address = _tblHomeBuilder["address"] as! String
        
        //the insert query
//        id INTEGER PRIMARY KEY AUTOINCREMENT, fName TEXT, lName TEXT, companyName TEXT, ACN TEXT, email TEXT, phoneNumber TEXT, username TEXT, password TEXT, positionHeld TEXT, paymentOptionId INTEGER
        let queryString = "INSERT INTO tblHomeBuilder (fName, lName, companyName, ACN, email, phoneNumber, mobileNumber, username, password, positionHeld, address ) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        //binding the parameters
        //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
        if sqlite3_bind_text(stmt, 1, fName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, lName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, companyName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, ACN, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, email, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 6, phoneNumber, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 7, mobileNumber, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 8, username, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 9, password, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 10, positionHeld, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 11, address, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        //displaying a success message
        print("Home Builder data saved successfully")
        return true
    }
    
    //********* saveJobsDataToDB
    func saveJobsDataToDB()->Bool {
        print(">>>>>>  SAVE Jobs DATA  <<<<<<<<")
        //creating a statement
        var stmt: OpaquePointer?
        
        let projectName = _tblJobs["projectName"] as! String
        let jobName = _tblJobs["jobName"] as! String
        let sellerName = _tblJobs["sellerName"] as! String
        let startDate = _tblJobs["startDate"] as! String
        let endDate = _tblJobs["endDate"] as! String
        let agreedPrice = _tblJobs["agreedPrice"] as! Int
        let isProgressBilling = _tblJobs["isProgressBilling"] as! Int
        let paymentOption = _tblJobs["paymentOption"] as! Int
        let jobDesc = _tblJobs["jobDesc"] as! String
        let jobCreatorType = _tblJobs["jobCreatorType"] as! Int
        let jobCreatorUsername = _tblJobs["jobCreatorUsername"] as! String
        let status = _tblJobs["status"] as! Int
        let actualStartDate = _tblJobs["actualStartDate"] as! String
        let actualEndDate = _tblJobs["actualEndDate"] as! String
        let completionDetails = _tblJobs["completionDetails"] as! String
        let deficiencies = _tblJobs["deficiencies"] as! String
        let declineComment = _tblJobs["declineComment"] as! String
        let buyerComment = _tblJobs["buyerComment"] as! String
        
        //the insert query
        let queryString = "INSERT INTO tblJobs (projectName, jobName, sellerName, startDate, endDate, agreedPrice, isProgressBilling, paymentOption, jobDesc, jobCreatorType, jobCreatorUsername, status, actualStartDate, actualEndDate, completionDetails, deficiencies, declineComment, buyerComment) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        //binding the parameters
        //int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
        if sqlite3_bind_text(stmt, 1, projectName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, jobName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, sellerName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, startDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, endDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 6, Int32(agreedPrice)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 7, Int32(isProgressBilling)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 8, Int32(paymentOption)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 9, jobDesc, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 10, Int32(jobCreatorType)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 11, jobCreatorUsername, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 12, Int32(status)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 13, actualStartDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 14, actualEndDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 15, completionDetails, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 16, deficiencies, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 17, declineComment, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 18, buyerComment, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        
        //displaying a success message
        print("Job saved successfully")
        
        //save data to payment table
        var list: clsPayments
        for ctr in 0..._tblPaymentList.count - 1 {
            list = _tblPaymentList[ctr]
            let jobID = list.jobID
            let paymentNumber = list.paymentNumber
            let amount = list.amount
            
            //initialize pointer
            stmt = nil
            
            //the insert query
            let queryString = "INSERT INTO tblPayments (jobID, paymentNumber, amount) VALUES (?,?,?)"
            
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            //let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_int(stmt, 1, Int32(jobID)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return false
            }
            
            if sqlite3_bind_int(stmt, 2, Int32(paymentNumber)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return false
            }
            
            if sqlite3_bind_int(stmt, 3, Int32(amount)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return false
            }
            
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting record: \(errmsg)")
                return false
            }
        }
        
        //displaying a success message
        print("Payments saved successfully")
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        return true
    }
    //********* save data to table
    func savePaymentDataToDB()->Bool {
        
        var stmt: OpaquePointer?

        let jobID = _tblPayments["jobID"] as! Int
        let paymentNumber = _tblPayments["paymentNumber"] as! Int
        let amount = _tblPayments["amount"] as! Int
        
        //the insert query
        let queryString = "INSERT INTO tblPayments(jobID, paymentNumber, amount) VALUES (?,?,?)"
        
        print(queryString)
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        print("1")
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(jobID)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        print("2")
        if sqlite3_bind_int(stmt, 2, Int32(paymentNumber)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        print("3")
        if sqlite3_bind_int(stmt, 12, Int32(amount)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        print("4")
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return false
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        //displaying a success message
        print("Payment data saved successfully")
        return true
    }
    
    //********* save Dispute Data to table
    func saveDisputeDataToDB()->Bool {
        
        print(">>>>>>  SAVE DISPUTE DATA  <<<<<<<<")
        //creating a statement
        var stmt: OpaquePointer?
        
        let jobID = _tblDisputes["jobID"] as! Int
        let disputeStatus = _tblDisputes["disputeStatus"] as! Int
        let natureOfDispute = _tblDisputes["natureOfDispute"] as! String
        let description = _tblDisputes["description"] as! String
        let proposedResolution = _tblDisputes["proposedResolution"] as! String
        
        //the insert query
        let queryString = "INSERT INTO tblDispute (jobID, disputeStatus, natureOfDispute, description, proposedResolution) VALUES (?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(jobID)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(disputeStatus)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, natureOfDispute, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, description, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, proposedResolution, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        
        //displaying a success message
        print("Dispute data saved successfully")
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        return true
    }
    
    //********* save Variation Data to table
    func saveVariationDataToDB()->Bool {
        
        print(">>>>>>  SAVE VARIATION DATA  <<<<<<<<")
        //creating a statement
        var stmt: OpaquePointer?
        
        let jobID = _tblVariations["jobID"] as! Int
        let variationStatus = _tblVariations["variationStatus"] as! Int
        let natureOfVariation = _tblVariations["natureOfVariation"] as! String
        let description = _tblVariations["description"] as! String
        let cost = _tblVariations["cost"] as! Int
        
        //the insert query
        let queryString = "INSERT INTO tblVariation (jobID, variationStatus, natureOfVariation, description, cost) VALUES (?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(jobID)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(variationStatus)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, natureOfVariation, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, description, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 5, Int32(cost)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        
        //displaying a success message
        print("Dispute data saved successfully")
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        return true
    }
    
    //********* save Posted Jobs Data to table
    func savePostedJobDataToDB()->Bool {
        
        print(">>>>>>  SAVE VARIATION DATA  <<<<<<<<")
        //creating a statement
        var stmt: OpaquePointer?
        
        let contactName = _tblPostedJobs["contactName"] as! String
        let jobName = _tblPostedJobs["jobName"] as! String
        let phone = _tblPostedJobs["phone"] as! String
        let email = _tblPostedJobs["email"] as! String
        let preferredStartDate = _tblPostedJobs["preferredStartDate"] as! String
        let jobDesc = _tblPostedJobs["jobDesc"] as! String
        let status = _tblVariations["status"] as! Int
        
        //the insert query
        let queryString = "INSERT INTO tblPostedJob (contactName, jobName, phone, email, preferredStartDate, jobDesc, status) VALUES (?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, contactName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, jobName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, phone, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, email, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, preferredStartDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 6, jobDesc, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int(stmt, 7, Int32(status)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting record: \(errmsg)")
            return false
        }
        
        //displaying a success message
        print("Posted Job data saved successfully")
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        return true
    }
    
    //************** readFromTempTable **************//
    func readFromTempTable(queryStr: String) {
        var tempTableList = [clsTempTable]()
        
        //first empty the list of heroes
        tempTableList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let det = String(cString: sqlite3_column_text(stmt, 2)) //sqlite3_column_int(stmt, 2)
            
            //adding values to list
            tempTableList.append(clsTempTable(id: Int(id), tempName: String(describing: name), tempDetails: String(describing: det)))
            
            var list: clsTempTable
            for ctr in 0...tempTableList.count - 1 {
                print(ctr)
                list = tempTableList[ctr]
                print("id -> ", list.id)
                print("name -> ", list.tempName)
                print("details -> ", list.tempDetails)
            }
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //************ readFromTableHomeOwner
    func readFromTableHomeOwner(queryStr: String)->Bool {
        
        print(">>>>>>>>>>> READ FROM TBLHOMEOWNER <<<<<<<<<<<<<<")
        //first empty the list of heroes
        _tblCurrentHomeOwnerData.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let fName = String(cString: sqlite3_column_text(stmt, 1))
            let lName = String(cString: sqlite3_column_text(stmt, 2))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let username = String(cString: sqlite3_column_text(stmt, 4))
            let password = String(cString: sqlite3_column_text(stmt, 5))
            let address = String(cString: sqlite3_column_text(stmt, 6))
            let phoneNumber = String(cString: sqlite3_column_text(stmt, 7))
            let mobileNumber = String(cString: sqlite3_column_text(stmt, 8))
            let paymentOptionId = sqlite3_column_int(stmt, 9)
            
            //adding values to list
            _tblCurrentHomeOwnerData.append(clsHomeOwner(id: Int(id),
                                              fName: String(describing: fName),
                                              lName: String(describing: lName),
                                              email: String(describing: email),
                                              username: String(describing: username),
                                              password: String(describing: password),
                                              address: String(describing: address),
                                              phoneNumber: String(describing: phoneNumber),
                                              mobileNumber: String(describing: mobileNumber),
                                              paymentOptionId: Int(paymentOptionId)
            ))
            
            //TEMP: set globals
            var list: clsHomeOwner
            for ctr in 0..._tblCurrentHomeOwnerData.count - 1 {
                list = _tblCurrentHomeOwnerData[ctr]  //index 0 because this will always fetch 1 record
                _currentUsername = list.username
                _currentFName = list.fName
                _currentLName = list.lName
                
                print(_currentUsername)
                print(_currentFName)
                print(_currentLName)
            }
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        if _tblCurrentHomeOwnerData.count > 0 {
            print("record found")
            return true
        } else {
            print("no record found")
            return false
        }
    }
    
    //*********** readFromTableHomeBuilder
    func readFromTableHomeBuilder(queryStr: String)->Bool {
        
        print(">>>>>>>>>>>>>>>>> READ FROM TBLHOME BUILDER <<<<<<<<<<<<<<<<<")
        //first empty the list of heroes
        _tblCurrentHomeBuilderData.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let fName = String(cString: sqlite3_column_text(stmt, 1))
            let lName = String(cString: sqlite3_column_text(stmt, 2))
            let companyName = String(cString: sqlite3_column_text(stmt, 3))
            let ACN = String(cString: sqlite3_column_text(stmt, 4))
            let email = String(cString: sqlite3_column_text(stmt, 5))
            let phoneNumber = String(cString: sqlite3_column_text(stmt, 6))
            let mobileNumber = String(cString: sqlite3_column_text(stmt, 7))
            let username = String(cString: sqlite3_column_text(stmt, 8))
            let password = String(cString: sqlite3_column_text(stmt, 9))
            let positionHeld = String(cString: sqlite3_column_text(stmt, 10))
            let address = String(cString: sqlite3_column_text(stmt, 11))
            
            //adding values to list
            _tblCurrentHomeBuilderData.append(clsHomeBuilder(id: Int(id),
                                              fName: String(describing: fName),
                                              lName: String(describing: lName),
                                              companyName: String(describing: companyName),
                                              ACN: String(describing: ACN),
                                              email: String(describing: email),
                                              phoneNumber: String(describing: phoneNumber),
                                              mobileNumber: String(describing: mobileNumber),
                                              username: String(describing: username),
                                              password: String(describing: password),
                                              positionHeld: String(describing: positionHeld),
                                              address: String(describing: address)
                            ))
            //TEMP: set globals
            var list: clsHomeBuilder
            
            for ctr in 0..._tblCurrentHomeBuilderData.count - 1 {
                list = _tblCurrentHomeBuilderData[ctr]  //index 0 because this will always fetch 1 record
                _currentUsername = list.username
                _currentFName = list.fName
                _currentLName = list.lName
                
                print(_currentUsername)
                print(_currentFName)
                print(_currentLName)
            }
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        if _tblCurrentHomeBuilderData.count > 0 {
            print("record found")
            return true
        } else {
            return false
        }
    }
    
    //*********** readFromTableJobs
    func readFromTableJobs(queryStr: String) {
        //var tempTableList = [clsJobs]()
        
        print(">>>>>>>>>> read from table JOBS <<<<<<<<<<<<<< ")
        //first empty the list of heroes
        _tblJobList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
    
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let projectName = String(cString: sqlite3_column_text(stmt, 1))
            let jobName = String(cString: sqlite3_column_text(stmt, 2))
            let sellerName = String(cString: sqlite3_column_text(stmt, 3))
            let startDate = String(cString: sqlite3_column_text(stmt, 4))
            let endDate = String(cString: sqlite3_column_text(stmt, 5))
            let agreedPrice = sqlite3_column_int(stmt, 6)
            let isProgressBilling = sqlite3_column_int(stmt, 7)
            let paymentOption = sqlite3_column_int(stmt, 8)
            let jobDesc = String(cString: sqlite3_column_text(stmt, 9))
            let jobCreatorType = sqlite3_column_int(stmt, 10)
            let jobCreatorUsername = String(cString: sqlite3_column_text(stmt, 11))
            let status = sqlite3_column_int(stmt, 12)
            let actualStartDate = String(cString: sqlite3_column_text(stmt, 13))
            let actualEndDate = String(cString: sqlite3_column_text(stmt, 14))
            let completionDetails = String(cString: sqlite3_column_text(stmt, 15))
            let deficiencies = String(cString: sqlite3_column_text(stmt, 16))
            let declineComment = String(cString: sqlite3_column_text(stmt, 17))
            let buyerComment = String(cString: sqlite3_column_text(stmt, 18))
            
            //adding values to list
            _tblJobList.append(clsJobs(id: Int(id),
                                    projectName: String(describing: projectName),
                                    jobName: String(describing: jobName),
                                    sellerName: String(describing: sellerName),
                                    startDate: String(describing: startDate),
                                    endDate: String(describing: endDate),
                                    agreedPrice: Int(agreedPrice),
                                    isProgressBilling: Int(isProgressBilling),
                                    paymentOption: Int(paymentOption),
                                    jobDesc: String(describing: jobDesc),
                                    jobCreatorType: Int(jobCreatorType),
                                    jobCreatorUsername: String(describing: jobCreatorUsername),
                                    status: Int(status),
                                    actualStartDate: String(describing: actualStartDate),
                                    actualEndDate: String(describing: actualEndDate),
                                    completionDetails: String(describing: completionDetails),
                                    deficiencies: String(describing: deficiencies),
                                    declineComment: String(describing: declineComment),
                                    buyerComment: String(describing: buyerComment)
                
            ))
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //*********** readFromTablePayments
    func readFromTablePayments(queryStr: String) {
        
        print(">>>>>>>>>> read from table tblPayments <<<<<<<<<<<<<< ")
        print("sqlString ->", queryStr)
        //first empty the list of heroes from an instance of the class clsPayments
        _tblPaymentList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let jobID = sqlite3_column_int(stmt, 1)
            let paymentNumber = sqlite3_column_int(stmt, 2)
            let amount = sqlite3_column_int(stmt, 3)
            
            //adding values to list
            _tblPaymentList.append(clsPayments(id: Int(id),
                                       jobID: Int(jobID),
                                       paymentNumber: Int(paymentNumber),
                                       amount: Int(amount)
            ))
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //*********** readFromTableDisputes
    func readFromTableDisputes(queryStr: String) {
        
        print(">>>>>>>>>> read from table tblDisputes <<<<<<<<<<<<<< ")
        print("sqlString ->", queryStr)
        //first empty the list of heroes from an instance of the class clsPayments
        _tblPaymentList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let jobID = sqlite3_column_int(stmt, 1)
            let disputeStatus = sqlite3_column_int(stmt, 2)
            let natureOfDispute = String(cString: sqlite3_column_text(stmt, 3))
            let description = String(cString: sqlite3_column_text(stmt, 4))
            let proposedResolution = String(cString: sqlite3_column_text(stmt, 5))
            
            //adding values to list
            _tblDisputeList.append(clsDisputes(id: Int(id),
                                               jobID: Int(jobID),
                                               disputeStatus: Int(disputeStatus),
                                               natureOfDispute: String(describing: natureOfDispute),
                                               description: String(describing: description),
                                               proposedResolution: String(describing: proposedResolution)
            ))
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //*********** readFromTableVariations
    func readFromTableVariation(queryStr: String) {
        
        print(">>>>>>>>>> read from table tblVariations <<<<<<<<<<<<<< ")
        //print("sqlString ->", queryStr)
        //first empty the list of variations
        _tblVariationList.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let jobID = sqlite3_column_int(stmt, 1)
            let variationStatus = sqlite3_column_int(stmt, 2)
            let natureOfVariation = String(cString: sqlite3_column_text(stmt, 3))
            let description = String(cString: sqlite3_column_text(stmt, 4))
            let cost = sqlite3_column_int(stmt, 5)
            
            //adding values to list
            _tblVariationList.append(clsVariations(id: Int(id),
                                                   jobID: Int(jobID),
                                                   variationStatus: Int(variationStatus),
                                                   natureOfVariation: String(describing: natureOfVariation),
                                                   description: String(describing: description),
                                                   cost: Int(cost)
            ))
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //read from tblPostedJobs
//    func readFromTableVariation(queryStr: String) {
//        
//        print(">>>>>>>>>> read from table tblVariations <<<<<<<<<<<<<< ")
//        //print("sqlString ->", queryStr)
//        //first empty the list of variations
//        _tblVariationList.removeAll()
//        
//        //statement pointer
//        var stmt:OpaquePointer?
//        
//        //preparing the query
//        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing insert: \(errmsg)")
//            return
//        }
//        
//        //traversing through all the records
//        while(sqlite3_step(stmt) == SQLITE_ROW){
//            let id = sqlite3_column_int(stmt, 0)
//            let jobID = sqlite3_column_int(stmt, 1)
//            let variationStatus = sqlite3_column_int(stmt, 2)
//            let natureOfVariation = String(cString: sqlite3_column_text(stmt, 3))
//            let description = String(cString: sqlite3_column_text(stmt, 4))
//            let cost = sqlite3_column_int(stmt, 5)
//            
//            //adding values to list
//            _tblVariationList.append(clsVariations(id: Int(id),
//                                                   jobID: Int(jobID),
//                                                   variationStatus: Int(variationStatus),
//                                                   natureOfVariation: String(describing: natureOfVariation),
//                                                   description: String(describing: description),
//                                                   cost: Int(cost)
//            ))
//        }
//        
//        if sqlite3_finalize(stmt) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error finalizing prepared statement: \(errmsg)")
//        }
//        stmt = nil
//        
//        //closedb
//        sqlite3_close(db)
//    }
    
    
    //*********** update record from table
    func updateTable(queryStr: String)->Bool {
        
        print(">>>>>>>>>> UPDATE RECORD <<<<<<<<<<<<<< ")
        print("sqlString ->", queryStr)
        var updateSuccess:Bool = false
        
        var stmt:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStr, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Successfully updated row.")
                updateSuccess = true
            } else {
                print("Could not update row.")
                updateSuccess = false
            }
        } else {
            print("UPDATE statement could not be prepared")
            updateSuccess = false
        }
        sqlite3_finalize(stmt)
        
        //closedb
        sqlite3_close(db)
        
        return updateSuccess
    }
    
    //get current job details
    //*********** readFromTableJobs
    func getCurrentJobDetailsFromTable(queryStr: String) {
        
        print(">>>>>>>>>> read from table JOBS <<<<<<<<<<<<<< ")
        //first empty the list of heroes
        _tblCurrentJobData.removeAll()
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let projectName = String(cString: sqlite3_column_text(stmt, 1))
            let jobName = String(cString: sqlite3_column_text(stmt, 2))
            let sellerName = String(cString: sqlite3_column_text(stmt, 3))
            let startDate = String(cString: sqlite3_column_text(stmt, 4))
            let endDate = String(cString: sqlite3_column_text(stmt, 5))
            let agreedPrice = sqlite3_column_int(stmt, 6)
            let isProgressBilling = sqlite3_column_int(stmt, 7)
            let paymentOption = sqlite3_column_int(stmt, 8)
            let jobDesc = String(cString: sqlite3_column_text(stmt, 9))
            let jobCreatorType = sqlite3_column_int(stmt, 10)
            let jobCreatorUsername = String(cString: sqlite3_column_text(stmt, 11))
            let status = sqlite3_column_int(stmt, 12)
            let actualStartDate = String(cString: sqlite3_column_text(stmt, 13))
            let actualEndDate = String(cString: sqlite3_column_text(stmt, 14))
            let completionDetails = String(cString: sqlite3_column_text(stmt, 15))
            let deficiencies = String(cString: sqlite3_column_text(stmt, 16))
            let declineComment = String(cString: sqlite3_column_text(stmt, 17))
            let buyerComment = String(cString: sqlite3_column_text(stmt, 18))
            
            //adding values to list
            _tblCurrentJobData.append(clsJobs(id: Int(id),
                                       projectName: String(describing: projectName),
                                       jobName: String(describing: jobName),
                                       sellerName: String(describing: sellerName),
                                       startDate: String(describing: startDate),
                                       endDate: String(describing: endDate),
                                       agreedPrice: Int(agreedPrice),
                                       isProgressBilling: Int(isProgressBilling),
                                       paymentOption: Int(paymentOption),
                                       jobDesc: String(describing: jobDesc),
                                       jobCreatorType: Int(jobCreatorType),
                                       jobCreatorUsername: String(describing: jobCreatorUsername),
                                       status: Int(status),
                                       actualStartDate: String(describing: actualStartDate),
                                       actualEndDate: String(describing: actualEndDate),
                                       completionDetails: String(describing: completionDetails),
                                       deficiencies: String(describing: deficiencies),
                                       declineComment: String(describing: declineComment),
                                       buyerComment: String(describing: buyerComment)
            ))
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
    }
    
    //check if user exist
    //routine: 1 - log in, 2 - registration
    //check if user exist
    func checkUser(queryStr: String)->Bool {
        //statement pointer
        var stmt:OpaquePointer?
        var recFound = false
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        //traversing through all the records
        if sqlite3_step(stmt) == SQLITE_ROW {
            
            _currentUsername = String(cString: sqlite3_column_text(stmt, 0))
            _currentFName = String(cString: sqlite3_column_text(stmt, 1))
            _currentLName = String(cString: sqlite3_column_text(stmt, 2))
            
            recFound = true
            print("record found")
        } else {
            print("from db, no record found")
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        //closedb
        sqlite3_close(db)
        
        return recFound
    }
    
    //get 
    func getLastJobID()->Int {
        var lastID: Int = 0
     
        var stmt:OpaquePointer?
        
        let queryStr = "SELECT MAX(id) FROM tblJobs"
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //traversing through all the records
        if sqlite3_step(stmt) == SQLITE_ROW {
            
            lastID = Int(sqlite3_column_int(stmt, 0))
            print("last ID -> ", lastID)
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        return lastID
    }
    
    //get last dispute id
    func getLastDisputeID()->Int {
        var lastID: Int = 0
        
        print("get last dispute id")
        
        var stmt:OpaquePointer?
        
        let queryStr = "SELECT MAX(id) FROM tblDispute"
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //traversing through all the records
        if sqlite3_step(stmt) == SQLITE_ROW {
            
            lastID = Int(sqlite3_column_int(stmt, 0))
            print("last ID -> ", lastID)
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        print(lastID)
        return lastID
    }
    
    
    func getLastID(queryStr: String)->Int {
        var lastID: Int = 0
        
        print("get last id")
        
        var stmt:OpaquePointer?
        
        //let queryStr = "SELECT MAX(id) FROM tblDispute"
        
        //preparing the query
        if sqlite3_prepare(db, queryStr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        //traversing through all the records
        if sqlite3_step(stmt) == SQLITE_ROW {
            
            lastID = Int(sqlite3_column_int(stmt, 0))
            print("last ID -> ", lastID)
        }
        
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        stmt = nil
        
        //closedb
        sqlite3_close(db)
        
        print(lastID)
        return lastID
    }
    
    //get current job status
    func getJobStatus(status: Int)-> String {
        // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed"
        switch status {
        case 1: return "Pending"
        case 2: return "Active"
        case 3: return "Completed"
        case 4: return "Declined"
        case 5: return "Closed"
        case 6: return "Pending Payment"
        default: return "Pending"
        }
    }
    
    //get current dispute status
    func getDisputeStatus(status: Int)-> String {
        // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed"
        switch status {
        case 1: return "Draft"
        case 2: return "Pending"
        case 3: return "Active"
        case 4: return "Resolved"
        default: return "Draft"
        }
    }
    
    //get current variation status
    func getVariationStatus(status: Int)-> String {
        // 1 - "Pending", 2 - "Active", 3 - "Completed", 4 - "Declined", 5 - "Closed"
        switch status {
        case 1: return "Draft"
        case 2: return "Pending"
        case 3: return "Active"
        case 4: return "Approved"
        case 5: return "Rejected"
        default: return "Draft"
        }
    }
    
    //get current data
    func fetchCurrentJobData() {
        if openDatabaseFile() == true {
            print("DB creation successfull")
            if createTable() == true {
                print("create table successful.")
                //fetch job details
                let sqlString: String = "SELECT * FROM tblJobs WHERE id = '" + String(globals.currentJobID) + "'"
                getCurrentJobDetailsFromTable(queryStr: sqlString)
            }
        } else {
            print("DB creation failed")
        }
    }
    
    
    //fetch payments data for the current job
    func fetchCurrentPaymentsData() {
        print(">>>> FETCH PAYMENT DATA <<<<")
        
        //fetch payment details
        if openDatabaseFile() == true {
            print("DB creation successfull")
            if createTable() == true {
                print("create table successful.")
                //fetch job details
                let sqlString: String = "SELECT * FROM tblPayments WHERE jobID = '" + String(globals.currentJobID) + "'"
                readFromTablePayments(queryStr: sqlString)
            }
        } else {
            print("DB creation failed")
        }
    }
}
