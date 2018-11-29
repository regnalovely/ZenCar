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
    let locationName:String?
    let enable:Bool?
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return locationName
    }
    
    var subtitle: String? {
        if(enable ?? false){
            return "Active"
        } else {
            return "Inactive"
        }
    }
    
    init(locationName:String?, coordinate:CLLocationCoordinate2D, enable:Bool) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.enable = enable
    }
    
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(CNPostalAddressStreetKey) : locationName]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(String(describing: locationName))"
        
        return mapItem
    }
}
