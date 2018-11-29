//
//  requeteSQL.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation
import SQLite

class RequeteSQL {
    
    var connect:Connection! // Objet permettant la connexion et manipulation à la base de donnée
    
    let tableStationnement = Table("stationnement") // Définition de la table Stationnement
    
    // Définition des propriétés de la table Stationnement
    let id = Expression<Int>("id")
    let nom = Expression<String>("nom")
    let latitude = Expression<Double>("latitude")
    let longitude = Expression<Double>("longitude")
    let favorite = Expression<Bool>("favoris")
    let date = Expression<String>("date")
    let enable = Expression<Bool>("enable")
    
    // Initialise l'objet requete en faisant la connexion et la création (si première utilisation) de la table Stationnement
    init() {
        connexion()
    }
    
    // Permet de faire la connexion à la base de donnée SQLite
    func connexion(){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
            let fileUrl = documentDirectory.appendingPathComponent("database").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            connect = database
            createTable()
        } catch {
            print(error)
        }
    }
    
    // Création de la table Stationnement
    func createTable() {
        let createTable = self.tableStationnement.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.nom)
            table.column(self.latitude)
            table.column(self.longitude)
            table.column(self.date)
            table.column(self.favorite)
            table.column(self.enable)
        }
        
        do {
            try self.connect.run(createTable)
        } catch {
            print(error)
        }
    }
    
    func dropTable(){
        let dropTable = self.tableStationnement.drop()
        
        do {
            try self.connect.run(dropTable)
        } catch {
            print(error)
        }
    }
    
    // Permet d'ajouter un stationnement
    func ajouterStationnemnet(stationnement:Stationnement) {
        // INSERT INTO Stationnement VALUES ($nom, $latitude, $longitude, $date, $favorite, $enable)
        let insert = self.tableStationnement.insert(self.nom <- stationnement.nom,
                                               self.latitude <- stationnement.latitude,
                                               self.longitude <- stationnement.longitude,
                                               self.date <- stationnement.date,
                                               self.favorite <- stationnement.isFavorite,
                                               self.enable <- stationnement.enable)
        
        do {
            try self.connect.run(insert)
            print("Le stationnement a bien été ajouté.")
        } catch {
            print(error)
        }
        
        reloadTableView()
    }
    
    // Permet de modifier un stationnement : Nom, Favoris, Enable
    func modifierStationnement(stationnement:Stationnement){
        let id = stationnement.id
        
        // UPDATE Stationnement SET nom = $nom, favorite = $favorite, enable = $enable
            // WHERE id = $id
        let filter = self.tableStationnement.filter(self.id == id)
        let update = filter.update(self.nom <- stationnement.nom,
                      self.favorite <- stationnement.isFavorite,
                      self.enable <- stationnement.enable)
        
        do {
            try self.connect.run(update)
            print("Le stationnement a bien été modifié.")
        } catch {
            print(error)
        }
        
        reloadTableView()
    }
    
    // Permet de supprimer un stationnement
    func supprimerStationnement(stationnement:Stationnement){
        let id = stationnement.id
        do {
            // DELETE FROM filter_table ( SELECT * FROM Stationnement WHERE id = $id )
                // DELETE FROM Stationnement WHERE id = $i
            let filter = self.tableStationnement.filter(self.id == id)
            let delete = filter.delete()
            try connect.run(delete)
        } catch {
            print(error)
        }
        reloadTableView()
    }
    
    // Retourne une liste de stationnements enregistrés
    func getStationnements() -> [Stationnement] {
        var liste = [Stationnement]()
        
        do {
            //SELECT * FROM Stationnement
            
            let locations = try self.connect.prepare(tableStationnement)
            for location in locations {
                let stationnement = createObjectStationnement(row: location)
                printStationnement(stationnement: stationnement)
                liste.append(stationnement)
            }
        } catch {
            print(error)
        }

        return liste
    }
    
    func getStationnement(id:Int) -> Stationnement {
        var stationnement = Stationnement()
        
        do {
            // SELECT * FROM Stationnement WHERE id = $id
            let filter = self.tableStationnement.filter(self.id == id)
            let select = try self.connect.prepare(filter)
            for row in select {
                stationnement = createObjectStationnement(row: row)
                //printStationnement(stationnement: stationnement)
            }
        } catch {
            print(error)
        }
        
        return stationnement
    }
    
    // Création d'un objet Stationnement depuis une ligne de la table Stationnement
        // de type Row (SQLite)
    func createObjectStationnement(row:Row) -> Stationnement {
        let stationnement = Stationnement()
        
        let id = row[self.id]
        let nom = row[self.nom]
        let latitude = row[self.latitude]
        let longitude = row[self.longitude]
        let date = row[self.date]
        let favorite = row[self.favorite]
        let enable = row[self.enable]
        
        stationnement.attribuerIdentifiant(id: id)
        stationnement.attribuerNom(nom: nom)
        stationnement.attribuerDate(date: date)
        stationnement.attribuerCoordonnees(latitude: latitude, longitude: longitude)
        
        if(favorite){
            stationnement.mettreFavoris()
        } else {
            stationnement.enleverFavoris()
        }
        
        if(enable){
            stationnement.activer()
        } else {
            stationnement.desactiver()
        }
        
        return stationnement
    }
    
    func printStationnement(stationnement:Stationnement){
        print(" - - - - - - - - - -")
        print("ID: \(stationnement.id)")
        print("NOM: \(stationnement.nom)")
        print("DATE: \(stationnement.date)")
        print("FAVORIS: \(stationnement.isFavorite)")
        print("ACTIF: \(stationnement.enable)")
        print(" - - - - - - - - - -")
    }
    
    func reloadTableView(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
}
