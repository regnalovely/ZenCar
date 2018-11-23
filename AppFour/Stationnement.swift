//
//  Stationnement.swift
//  AppFour
//
//  Created by etudiant on 21/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class Stationnement{
    var nomStationnement:String
    var isFavorite:Bool
    var altitude:Double
    var longitude:Double
    var date:String
    
    init(nomStationnement:String){
        self.nomStationnement = nomStationnement
        self.isFavorite = false
        self.altitude = 0
        self.longitude = 0
        self.date = Calendar.current.description
    }
    
    func modifierStationnement(nom:String){
        nomStationnement = nom
    }
    
    func ajouterCoordonnees(altitude:Double, longitude:Double){
        self.altitude = altitude
        self.longitude = longitude
    }
}
