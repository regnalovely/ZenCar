//
//  ViewController.swift
//  AppFive
//
//  Created by etudiant on 05/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class Enregistrement: UIViewController {
	
    var latitude:Double = 0.0
    var longitude:Double = 0.0
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        envoyer()
    }
	
	// Fonction permettant de renvoyer une chaine de caractère selon un tableau de key/value donné
	func getParameters(parameters:[[String:String]]) -> String {
		var param:String = ""
		
		for parameter in parameters {
			param += "\(parameter["name"]!)=\(parameter["value"]!)&"
		}
		
		param.removeLast()

		return param
	}
	
    func envoyer() {
		//var stat:String = "Statut..."
		
		// L'URL de notre API
        let url = URL(string: "https://buvette-univ.zd.fr/")!
		
		// 	Tableau de key/value à envoyer dans la requête http
		//	C'est plus lisible et plus facile à implémenter qu'une chaine de caractère
		let tabParam = [
			["name":"latitude", "value":latitude],
			["name":"longitude", "value":longitude],
			["name":"fonction", "value":"enregistrerLocalisation"]
		]
		
		// Récupère la chaine de caractère
        let param = getParameters(parameters: tabParam as! [[String : String]])
		
		var request = URLRequest(url: url)
        request.httpMethod = "POST"
		request.httpBody = param.data(using: .utf8)
        
		let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in if error != nil {
				print("ERROR : \(String(describing: error))")
				return
			}
			do {
				if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					print(json)
				}
			} catch let error {
				print(error.localizedDescription)
			}
        })
        task.resume()
    }
}
