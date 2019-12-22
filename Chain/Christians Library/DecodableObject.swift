//
//  DecodableObject.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 3/15/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation

class DecoableObject:NSObject, NSCoding{
    
    var _calories:Int = 0
    var _carbs:String = "0.0"
    var _netCarbs:String = "0.0"
    var _netProtein:String = "0.0"
    var _fat:String = "0.0"
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_calories, forKey: "calories")
        aCoder.encode(_carbs, forKey: "carbs")
        aCoder.encode(_netCarbs, forKey: "netCarbs")
        aCoder.encode(_netProtein, forKey: "netProtein")
        aCoder.encode(_fat, forKey: "fat")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let calories = aDecoder.decodeInteger(forKey: "calories")
        let carbs = aDecoder.decodeObject(forKey: "carbs") as! String
        let netCarbs = aDecoder.decodeObject(forKey: "netCarbs") as! String
        let netProtein = aDecoder.decodeObject(forKey: "netProtein") as! String
        let fat = aDecoder.decodeObject(forKey: "fat") as! String
        
        self.init(cals: calories, carbs: carbs, netCarbs: netCarbs, protein: netProtein, fats: fat)
        
    }
    
    init(cals:Int, carbs:String, netCarbs:String, protein:String, fats:String){
        self._calories = cals
        self._carbs = carbs
        self._netCarbs = netCarbs
        self._netProtein = protein
        self._fat = fats

    }
}
