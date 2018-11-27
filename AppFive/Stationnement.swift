//
//  Stationnement.swift
//  AppFive
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class Stationnement{
    var idStationnement:Int // Permet d'identifié le stationnement
    var nomStationnement:String // Permet à l'utilisateur d'identifié le stationnement
    var isFavorite:Bool // Savoir si le stationnement est dans les favoris de l'utilisateur
    var latitude:Double // Coordonnée du stationnement
    var longitude:Double // Coordonnée du stationnement
    var date:String // Date de l'enregistrement du stationnement
    
    init(latitude:Double, longitude:Double){
        // Initialise un nom selon la date de placement du point de stationnement
        let initialDatedName = Calendar.current.description
        
        idStationnement = 0
        nomStationnement = initialDatedName
        self.latitude = latitude
        self.longitude = longitude
        isFavorite = false
        date = initialDatedName
    }
    
    // Permet de donner un identifiant autre que celui initial
    func attribuerIdentifiant(identifiant:Int){
        idStationnement = identifiant
    }
    
    // Permet de donner un nom choisi par l'utilisateur au stationnement
    func attribuerNom(nom:String){
        nomStationnement = nom
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
    
    func toString(){
        print(nomStationnement)
    }
}
