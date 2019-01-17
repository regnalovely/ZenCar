//
//  Stationnement.swift
//  AppFive
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class Stationnement: NSObject {
    var id:Int! // Permet d'identifié le stationnement
    var nom:String! // Permet à l'utilisateur d'identifié le stationnement
    var latitude:Double! // Coordonnée du stationnement
    var longitude:Double! // Coordonnée du stationnement
    var date:String! // Date de l'enregistrement du stationnement
    var isFavorite:Bool = false // Savoir si le stationnement est dans les favoris de l'utilisateur
    var enable:Bool = true // Savoir si le stationnement est actif ou non
    
    override init(){
        super.init()
        
        // Par défault ID à 0
        self.id = 0
        // Initialise la date du placement du stationnement
        let now = getDefaultDate(format: "dd/MM/yyyy HH:mm")
        self.date = now
        // Le nom du stationnement par défaut
        let date = getDefaultDate(format: "dd-MM-yyyy-HH:mm")
        self.nom = "STA-\(date)"
        self.latitude = 0
        self.longitude = 0
        
    }
    
    init(latitude:Double, longitude:Double){
        super.init()
        
        // Par défault ID à 0
        self.id = 0
        // Initialise la date du placement du stationnement
        let now = getDefaultDate(format: "dd/MM/yyyy HH:mm")
        self.date = now
        // Le nom du stationnement par défaut
        let date = getDefaultDate(format: "dd-MM-yyyy-HH:mm")
        self.nom = "STA-\(date)"
        // Les coordonnées du stationnement
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
    
    func getDefaultDate(format:String) -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "FR_fr")
        formatter.dateFormat = format
        let date = formatter.string(from: now)
        
        return date
    }
}
