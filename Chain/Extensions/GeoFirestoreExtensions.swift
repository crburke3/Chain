//
//  GeoFirestoreExtensions.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/27/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import Geofirestore
import GeoFire
import MapKit

extension GeoFirestore{
    public static func getFirestoreData(for coordinate: CLLocationCoordinate2D)->[String:Any]?{
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        if let geoHash = GFGeoHash(location: coordinate).geoHashValue {
    return ["l" : [lat,lon], "g": geoHash]
        }
        return nil
    }
}
