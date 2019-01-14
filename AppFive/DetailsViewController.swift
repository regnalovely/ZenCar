//
//  DetailsViewController.swift
//  AppFive
//
//  Created by etudiant on 27/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var name:String!
    
    var stationnement:Stationnement!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAudio" {
            let controller = segue.destination as? AudioViewController
            controller?.name = name
        }
        if segue.identifier == "showPhoto" {
            let controller = segue.destination as? CameraViewController
            controller?.albumName = name
        }
    }

}
