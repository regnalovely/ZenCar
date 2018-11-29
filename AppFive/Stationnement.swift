//
//  Stationnement.swift
//  AppFive
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class Stationnement: NSObject {
    var id:Int // Permet d'identifié le stationnement
    var nom:String // Permet à l'utilisateur d'identifié le stationnement
    var latitude:Double // Coordonnée du stationnement
    var longitude:Double // Coordonnée du stationnement
    var date:String // Date de l'enregistrement du stationnement
    var isFavorite:Bool = false // Savoir si le stationnement est dans les favoris de l'utilisateur
    var isExpandable:Bool = false // Collapse dans la tableView
    var enable:Bool = true // Savoir si le stationnement est actif ou non
    
    override init(){
        id = 0
        nom = "STA-000"
        latitude = 0
        longitude = 0
        date = "00/00/0000 00:00"
    }
    
    init(latitude:Double, longitude:Double){
        // Initialise un nom selon la date de placement du point de stationnement
        let date = Date()
        let locale = Locale(identifier: "fr_MQ")
        self.date = date.description(with: locale)
        
        id = 0
        nom = "STA-000"
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Permet de donner un identifiant autre que celui initial
    func attribuerIdentifiant(id:Int){
        self.id = id
    }
    
    // Permet de donner un nom choisi par l'utilisateur au stationnement
    func attribuerNom(nom:String){
        self.nom = nom
    }
    
    // Permet de renseigner les coordonnées du stationnement
    func attribuerCoordonnees(latitude:Double, longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func attribuerDate(date:String){
        self.date = date
    }
    
    // Permet d'indiquer que ce stationnement est dans les favoris de l'utilisateur
    func mettreFavoris(){
        isFavorite = true
    }
    
    // Permet d'indiquer que ce stationnement n'est pas dans les favoris de l'utilisateur
    func enleverFavoris(){
        isFavorite = false
    }
    // Permet d'indiquer que ce stationnement est en cours d'utilisation
    func activer(){
        enable = true
    }
    
    // Permet d'indiquer que ce stationnement n'est pas en cours d'utilisation
    func desactiver(){
        enable = false
    }
}
