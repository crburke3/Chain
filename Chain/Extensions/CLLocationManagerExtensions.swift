//
//  CLLocationManagerExtensions.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/27/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationManager{
    func getCurrentLocation()->CLLocation?{
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            if let appleLocation = self.location{
                return appleLocation
            }
        }else{
            print("user has not authorized location management")
        }
        return nil
    }
}
