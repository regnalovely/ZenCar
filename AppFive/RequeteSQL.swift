//
//  RequeteSQL.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation
import SQLite3

class RequeteSQL {
    var db:OpaquePointer?
    var nom:String!
    var latitude:Double!
    var longitude:Double!
    var date:String!
    
    init(){
        connexion()
    }
    
    func connexion() {
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            .appendingPathComponent("database.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Erreur de connexion à la base de donnée")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS stationnement(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, favorite INTEGER, latitude DOUBLE, longitude DOUBLE, date TEXT)", nil, nil, nil) != SQLITE_OK {
            let error = String(cString:sqlite3_errmsg(db)!)
            print("Erreur lors de la création de la table \(error)")
        }
    }
    
    func enregistrerStationnement(stationnement:Stationnement){

        if stationnement.date == "" {
            date = Calendar.current.description
        } else {
            date = stationnement.date
        }
        
        if stationnement.nomStationnement == "" {
            nom = "STA-\(String(describing: date))"
        } else {
            nom = stationnement.nomStationnement
        }
        
        if stationnement.latitude == 0 {
            return
        } else {
            latitude = stationnement.latitude
        }
        
        if stationnement.longitude == 0 {
            return
        } else {
            longitude = stationnement.longitude
        }

        var sql:OpaquePointer?
        let query = "INSERT INTO stationnement VALUES(null,?,0,?,?,?)"
        
        if sqlite3_prepare(db, query, -1, &sql, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors de la préparation de la requête INSERT \(error)")
            return
        }
        
        if sqlite3_bind_text(sql, 1, nom, -1, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors l'ajout du paramètre NOM de la requête INSERT \(error)")
            return
        }
        
        if sqlite3_bind_double(sql, 2, latitude) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors l'ajout du paramètre LATITUDE de la requête INSERT \(error)")
            return
        }
        
        if sqlite3_bind_double(sql, 3, longitude) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors l'ajout du paramètre LONGITUDE de la requête INSERT \(error)")
            return
        }
        
        if sqlite3_bind_text(sql, 4, nom, -1, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors l'ajout du paramètre DATE de la requête INSERT \(error)")
            return
        }
    }
    
    func getStationnement() -> [Stationnement] {
        var listeStationnement = [Stationnement]()
        let query = "SELECT * FROM stationnement"
        var sql:OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &sql, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error lors de la préparation de la requête SELECT \(error)")
        }
        
        while(sqlite3_step(sql) == SQLITE_ROW){
            let id = sqlite3_column_int(sql, 0)
            let nom = String(cString:sqlite3_column_text(sql, 1))
            let favorite = sqlite3_column_int(sql, 2)
            let latitude = sqlite3_column_double(sql, 3)
            let longitude = sqlite3_column_double(sql, 4)
            let date = String(cString:sqlite3_column_text(sql, 5))
            
            let stationnement = Stationnement(latitude: latitude, longitude: longitude)
            stationnement.attribuerIdentifiant(identifiant: Int(id))
            stationnement.attribuerNom(nom: nom)
            stationnement.attribuerDate(date: date)
            
            if(favorite == 1){
                stationnement.mettreFavoris()
            }
            
            listeStationnement.append(stationnement)
        }
        
        return listeStationnement
    }
}
