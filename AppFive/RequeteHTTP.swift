//
//  RequeteHTTP.swift
//  AppFive
//
//  Created by etudiant on 05/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import Foundation

class RequeteHTTP {
    
    // L'URL de l'API
    let url = URL(string: "https://buvette-univ.zd.fr/")!
    
	// Fonction permettant de renvoyer une chaine de caractère selon un tableau de key/value donné
	func getParameters(parameters:[[String:String]]) -> String {
		var param:String = ""
		
		for parameter in parameters {
			param += "\(parameter["name"]!)=\(parameter["value"]!)&"
		}
		
        // Enlève le dernier caractère ("&") à la chaine de caractère param
		param.removeLast()

		return param
	}
	
    // Fonction permettant d'envoyer des données par requête HTTP
    func envoyer(stationnement:Stationnement) -> NSDictionary {
        // Réponse de la requête
        var reponse = NSDictionary()

		// 	Tableau de key/value à envoyer dans la requête http
		//	C'est plus lisible et plus facile à implémenter qu'une chaine de caractère
		let tabParameters = [
            ["name":"nom", "value":stationnement.nomStationnement],
			["name":"latitude", "value":stationnement.latitude],
			["name":"longitude", "value":stationnement.longitude],
			["name":"fonction", "value":"enregistrerStationnement"]
		]
		
		// Récupère la chaine de caractère qui servira pour l'envoi des paramètres
        let param = getParameters(parameters: tabParameters as! [[String : String]])
		
        // Initialise la requête HTTP et ses caractéristiques
		var request = URLRequest(url: url)
        request.httpMethod = "POST" // J'ai choisi la méthode pour l'envoi de la requête
		request.httpBody = param.data(using: .utf8) // encodage en UTF8 pour les caractères spéciaux
        
        // Initialise la tâche permettant de procéder à l'envoi de la requête HTTP
		let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in if error != nil {
            reponse = ["error":String(describing: error)]
            print("ERROR : \(String(describing: error))")
				return
			}
			do {
                // Récupère l'objet JSON reçu par l'API qui est la réponse de la requête HTTP
				if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					reponse = json
				}
			} catch let error { // Si le JSON n'a pu être initialiser
                reponse = ["error":error.localizedDescription]
                print(error.localizedDescription)
			}
        })
        // Ferme la tâche
        task.resume()
        
        // Retourne la réponse reçu par la requête
        return reponse
    }
}
