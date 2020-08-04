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
            
            statusLbl.text = "Contact Added"
            name.text = ""
            address.text = ""
            phone.text = ""

        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }

    @IBAction func findBtnPressed(_ sender: UIButton) {
        
    }

}

