//
//  requeteSQL.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation
import SQLite

class requeteSQL {
    
    var db:Connection!
    
    func connexion(){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
            let fileUrl = documentDirectory.appendingPathComponent("database").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            db = database
        } catch {
            print(error)
        }
    }
    
    func createTable(){
        //let createTable = self
    }
}
