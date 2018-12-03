//
//  ViewController.swift
//  AppFive
//
//  Created by etudiant on 23/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Objects
    @IBOutlet weak var map: MKMapView!
    let manager:CLLocationManager = CLLocationManager()
    let requeteSQL:RequeteSQL = RequeteSQL()
    
    // MARK: - Location's Variables
    var currentLocation:CLLocation = CLLocation()
    var currentPlacemark:CLPlacemark?
    var carLocation:CLLocation?
    var userHeading:CLHeading?
    
    // MARK: - Mes variables
    let zoom:Double = 0.001
    var searching:Bool = false
    var locations = [Location]()
    
    // MARK: - Controller's Fonctions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removePoint),
                                               name: NSNotification.Name(rawValue: "reloadMap"),
                                               object:nil)
        localisation()
        createTestPins()
        updateLocations()
        manageMapView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        map.setRegion(region, animated: true)
        
        //manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.headingAccuracy
        print(heading)
        
        let magnitude = heading.magnitude
        print(magnitude)
        
        //userHeading = heading
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            if let annotation = annotation as? Location {
                if annotation.enable == true {
                    let identifier = "pin"
                    var view:MKPinAnnotationView
                    if let dequeuedView = map.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                        dequeuedView.annotation = annotation
                        view = dequeuedView
                    } else {
                        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                        view.canShowCallout = true
                        view.calloutOffset = CGPoint(x: -5, y: 5)
                        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                    }
                    return view
                }
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let location = view.annotation as! Location
        self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // MARK: - Mes fonctions
    
    func createTestPins(){
        let locationTestCoordinate:[CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 14.471044, longitude: -60.927200),
            CLLocationCoordinate2D(latitude: 14.569967, longitude: -60.961610),
            CLLocationCoordinate2D(latitude: 14.575902, longitude: -60.97479),
            CLLocationCoordinate2D(latitude: 14.622981, longitude: -60.990254),
            CLLocationCoordinate2D(latitude: 14.619652, longitude: -61.094465)
        ]
        var i = 0;
        for coordinate in locationTestCoordinate {
            i += 1
            let name = "Test\(i)"
            let location = Location(name: name, coordinate: coordinate, enable: false)
            locations.append(location)
        }
    }
    
    func manageMapView(){
        map.delegate = self
        map.showsScale = true
        map.showsCompass = true
        map.showsTraffic = true
    }

    func localisation() {
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            map.showsUserLocation = true
        }
    }
    
    @objc func updateLocations(){
        // Création des points de stationnements
        let tabStationnement = requeteSQL.getStationnements()
        for stationnement in tabStationnement {
            // Récupère les coordonnées des stationnements
            let coordinate = CLLocationCoordinate2D(latitude: stationnement.latitude, longitude: stationnement.longitude)
            // Crée un objet de type Location(MKAnnotation)
            let location = Location(name: stationnement.nom, coordinate: coordinate, enable: stationnement.enable)
            // On stock l'objet dans la collection de position des stationnements
            locations.append(location)
        }
        map.addAnnotations(locations)
    }
    
    @objc func removePoint(data:[String:Stationnement]){
        let stationnement:Stationnement = data["stationnement"]!
        let coordinate =  CLLocationCoordinate2D(latitude: stationnement.latitude,
                                                 longitude: stationnement.longitude)
        let location:Location = Location(name: stationnement.nom,
                                         coordinate: coordinate,
                                         enable: stationnement.enable)
        print(location.name!)
        map.removeAnnotation(location)
    }
    
    func placerStationnement(){
        // Création de l'objet stationnement
        let stationnement = Stationnement(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        // Création d'une alerte demandant la saisie d'un nom de stationnement à l'utilisateur
        let alert = UIAlertController(title: "Nouveau stationnement", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Nom du stationnement"}
        
        let action = UIAlertAction(title: "Valider", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text
                else { return }

            if name != "" {
                // Attribue le nom saisi par l'utilisateur au stationnement
                stationnement.attribuerNom(nom: name)
                
                // Appelle la requête permettant d'enregistrer le stationnement
                self.requeteSQL.ajouterStationnemnet(stationnement: stationnement)
                
                // Récupère les coordonnées du stationnement
                let coordinate = CLLocationCoordinate2D(latitude: stationnement.latitude, longitude: stationnement.longitude)
                
                // Crée un objet de type Location(MKAnnotation)
                let location = Location(name: stationnement.nom, coordinate: coordinate, enable: stationnement.enable)
                
                // On stock l'objet dans la collection de position des stationnements
                self.locations.append(location)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getDirections(){
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirections.Request()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        // directions / route
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (directionsResponse, error) in
            guard let directionsResponse = directionsResponse else {
                if let error = error {
                    print("Erreur de directions \(error.localizedDescription)")
                }
                return
            }
            
            let route = directionsResponse.routes[0]
            self.map!.addOverlay(route.polyline, level: .aboveRoads)
            
            let routeRect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(routeRect), animated: true)
        }
    }
    
    func search(){
        // manager.startUpdatingLocation()

        //let distance:CLLocationDistance = currentLocation.distance(from: carLocation!) / 1000
        //let direction:CLLocationDirection = currentLocation.course
        
        //print("DISTANCE: \(String(format: "%.01f km", distance))")
        //print("DIRECTION: \(direction)")
    }
    
    // MARK: - Button Action
    
    @IBAction func isHere() {
        if searching == false {
            print("Station mode activate")
            carLocation = currentLocation
            placerStationnement()
        }
    }
    
    @IBAction func whereIs() {
        print("Searching mode activate")
        searching = true
        //search()
        getDirections()
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
}
