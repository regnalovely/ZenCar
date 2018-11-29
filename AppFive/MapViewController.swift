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
    
    @IBOutlet weak var map: MKMapView!
    let manager:CLLocationManager = CLLocationManager()
    let requeteSQL:RequeteSQL = RequeteSQL()
    let zoom:Double = 0.001
    
    var searching:Bool = false
    
    var locationCoordinate:CLLocationCoordinate2D?
    
    var carLocation:CLLocation?
    var carPlacemark:CLPlacemark?
    
    var currentLocation:CLLocation?
    var currentPlacemark:CLPlacemark?
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocations), name: NSNotification.Name(rawValue: "reload"), object: nil)
        localisation()
        updateLocations()
        manageMapView()
    }
    
    func manageMapView(){
        map.delegate = self
        map.showsScale = true
        map.showsCompass = true
        map.showsTraffic = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        locationCoordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude,
                                                    longitude: currentLocation!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: locationCoordinate!, span: span)
        map.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
        
        if(searching){
            let distance:CLLocationDistance = currentLocation!.distance(from: carLocation!) / 1000
            let direction:CLLocationDirection = currentLocation!.course

            print("DISTANCE: \(String(format: "%.01f km", distance))")
            print("DIRECTION: \(direction)")
        }
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
        annotation.coordinate = locationCoordinate!
        map.addAnnotation(annotation)
    }
    
    func updateLocations(){
        // Vide la collection actuelle de positions de stationnements
        locations.removeAll()
        // Création des points de stationnements
        let tabStationnement = requeteSQL.getStationnements()
        for stationnement in tabStationnement {
            // Récupère les coordonnées des stationnements
            let coordinate = CLLocationCoordinate2D(latitude: stationnement.latitude, longitude: stationnement.longitude)
            // Crée un objet de type Location(MKAnnotation)
            let location = Location(locationName: stationnement.nom, coordinate: coordinate, enable: stationnement.enable)
            // On stock l'objet dans la collection de position des stationnements
            locations.append(location)
        }
        map.addAnnotations(locations)
    }
    
    func placerStationnement(){
        // Placement du point de stationnement
        placerPoint()
        
        // Création de l'objet stationnement
        let stationnement = Stationnement(latitude: locationCoordinate!.latitude, longitude: locationCoordinate!.longitude)
        
        // Création d'une alerte demandant la saisie d'un nom de stationnement à l'utilisateur
        let alert = UIAlertController(title: "Nouveau stationnement", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Nom du stationnement"}
        let action = UIAlertAction(title: "Valider", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text
                else { return }

            if name != "" {
                stationnement.attribuerNom(nom: name)
                self.requeteSQL.ajouterStationnemnet(stationnement: stationnement)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Location {
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

        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let location = view.annotation as! Location
        print("LOCATION SELECTED: \(location.coordinate)")
        self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    // MARK: - Button Action
    
    @IBAction func isHere() {
        if searching == false {
            carLocation = currentLocation
            placerStationnement()
        }
    }
    
    @IBAction func whereIs() {
        searching = true
        print("Searching mode activate")
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
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
}
