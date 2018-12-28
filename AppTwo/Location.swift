//
//  Location.swift
//  AppFive
//
//  Created by etudiant on 29/11/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import MapKit
import AddressBook
import CoreLocation
import Contacts

class Location: NSObject, MKAnnotation {
    let name:String?
    let enable:Bool?
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        if(enable == true){
            return "Active"
        } else {
            return "Inactive"
        }
    }
    
    init(name:String?, coordinate:CLLocationCoordinate2D, enable:Bool) {
        self.name = name
        self.coordinate = coordinate
        self.enable = enable
    }
    
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(CNPostalAddressStreetKey) : name]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(String(describing: name))"
        
        return mapItem
    }
}
