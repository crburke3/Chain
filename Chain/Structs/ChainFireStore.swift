//
//  File.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import CoreLocation
import Geofirestore
import Firebase

class ChainFireStore {
    //
    let locationManager = CLLocationManager()
    var userLat: Double = 0.0
    var userLong: Double = 0.0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLat = locValue.latitude //Is in degrees but userLat is Double
        userLong = locValue.longitude //Successfully transfers to double
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .restricted: break
        case .denied:
            NSLog("do some error handling")
            break
        default:
            locationManager.startUpdatingLocation()
        }
    }
    
    func createChain() {
        let geoFirestoreRef = Firestore.firestore().collection("chains")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        let currentTime = Date()
        let date = currentTime.toChainString() //Date string
        let tempId = geoFirestoreRef.document().documentID //Generate new document
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let docData = ["count" : 1, "likes" : 0, "posts" : [[:]], "tag1" : "", "tag 2" : "", "timePeriod" : 0, "timeStamp" : date, "users" : [currentUser]]
        geoFirestoreRef.document(tempId).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        geoFirestore.setLocation(location: CLLocation(latitude: userLat, longitude: userLong), forDocumentWithID: tempId) { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
        
    
    }
    
    
    
}
