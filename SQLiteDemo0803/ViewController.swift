//
//  ViewController.swift
//  SQLiteDemo0803
//
//  Created by leslie on 8/3/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var statusLbl: UILabel!

    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDB()
    }

    //MARK: - Creating the Database and Table
    func initDB() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("contacts.db").path
        
        if !filemgr.fileExists(atPath: databasePath) {
            
            ///0. create Database
            ///1. open Database
            ///2. prepares a SQL statement to create the contacts table in the database
            ///3. executes it via a call to the FMDB executeStatements method of the database instance.
            ///4. close Database
            let contactDB = FMDatabase(path: databasePath)
            
            if contactDB.open() {
                ///FMDB uses strings for all your SQL commands (CREATE, INSERT, DELETE, etc.).
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                ///This executes a series of SQL statements
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                ///After finished manipulating DB, close it.
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }
    
    //MARK: - Save Data to the SQLite Database
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        ///0. create Database
        ///1. open Database
        ///2. prepares a SQL statement to create the contacts table in the database
        ///3. executes it via a call to the FMDB executeStatements method of the database instance.
        ///4. close Database
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text ?? "")', '\(address.text ?? "")', '\(phone.text ?? "")')"
            
            do {
                try contactDB.executeUpdate(insertSQL, values: nil)
            } catch {
                statusLbl.text = "Failed to add contact"
                print("Error: \(error.localizedDescription)")
            }
            
            ///After finished manipulating DB, close it.
            contactDB.close()

            statusLbl.text = "Contact Added"
            name.text = ""
            address.text = ""
            phone.text = ""

        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }

    //MARK: - Extract Data from the SQLite Database
    @IBAction func findBtnPressed(_ sender: UIButton) {
        ///0. create Database
        ///1. open Database
        ///2. prepares a SQL statement to create the contacts table in the database
        ///3. executes it via a call to the FMDB executeStatements method of the database instance.
        ///4. close Database
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let querySQL =  "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text!)'"
            
            do {
                let results: FMResultSet? = try contactDB.executeQuery(querySQL, values: nil)
                
                ///You must always invoke `next` to access the values returned in a query, even if you're only expecting one.
                if results?.next() == true {
                    address.text = results?.string(forColumn: "address")
                    phone.text = results?.string(forColumn: "phone")
                    statusLbl.text = "Record Found"
                } else {
                    statusLbl.text = "Record not found"
                    address.text = ""
                    phone.text = ""
                }
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            contactDB.close()
            
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

}

