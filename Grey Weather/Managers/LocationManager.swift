//
//  LocationManagers.swift
//  Grey Weather
//
//  Created by FAO on 24/10/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Creating an instance of CLLocationManager, the framework we use to get the coordinates
    var manager: CLLocationManager?
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        // Assigning a delegate to our CLLocationManager instance
        checkIfLocationServieIsEnabled()
    }
    
    func checkIfLocationServieIsEnabled() {
            manager = CLLocationManager()
            manager?.delegate = self
    }
    
    private func checkLocationAuthorization(){
        guard let manager = manager else {fatalError("null instead of object") }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            self.requestLocation()
            break
        @unknown default:
            break
        }
    }
    
    // Requests the one-time delivery of the user’s current location, see https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
    func requestLocation() {
        isLoading = true
        manager?.requestLocation()
    }
    
    
    // Set the location coordinates to the location variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    
    // This function will be called if we run into an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
    
    //MARK: Location manager
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}


