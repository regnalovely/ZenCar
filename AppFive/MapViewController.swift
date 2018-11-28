//
//  ViewController.swift
//  AppFive
//
//  Created by etudiant on 23/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    let manager:CLLocationManager = CLLocationManager()
    var point:CLLocationCoordinate2D = CLLocationCoordinate2D()
    let requeteSQL:RequeteSQL = RequeteSQL()
    let historyController:HistoryViewController = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        localisation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let locationCoordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        map.setRegion(region, animated: true)
        point = locationCoordinate
        manager.stopUpdatingLocation()
    }

    func localisation() {
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            map.showsUserLocation = true
        }
    }

    func placerPoint(){
        // Création du point sur la map
        let annotation = MKPointAnnotation()
        annotation.title = "Votre voiture est ici"
        annotation.coordinate = point
        map.addAnnotation(annotation)
    }
    
    func placerStationnement(){
        // Placement du point de stationnement
        placerPoint()
        
        // Création de l'objet stationnement
        let stationnement = Stationnement(latitude: point.latitude, longitude: point.longitude)
        
        let alert = UIAlertController(title: "Nouveau stationnement", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Nom du stationnement"}
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text
                else { return }
            print(name)
            if name != "" {
                stationnement.attribuerNom(nom: name)
                self.requeteSQL.ajouterStationnemnet(stationnement: stationnement)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Button Action
    
    @IBAction func isHere() {
        placerStationnement()
    }
    
    @IBAction func whereIs() {
        //
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
}
