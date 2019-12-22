//
//  File.swift
//  FlexForum
//
//  Created by Christian Burke on 4/18/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

func saveString(str:String?, location:String){
    let saveData = NSKeyedArchiver.archivedData(withRootObject: str)
    UserDefaults.standard.set(saveData, forKey: location)
}

func saveString(str:String?, location:SaveKeys){
    let saveData = NSKeyedArchiver.archivedData(withRootObject: str)
    UserDefaults.standard.set(saveData, forKey: location.rawValue)
}

func loadString(ident:String)->String?{
    let decoded  = UserDefaults.standard.object(forKey: ident) as! Data?
    if(decoded != nil){
        if let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? String{
            return decodedTeams
        }
    }
    return nil
}

func loadString(ident:SaveKeys)->String?{
    let decoded  = UserDefaults.standard.object(forKey: ident.rawValue) as! Data?
    if(decoded != nil){
        if let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? String{
            return decodedTeams
        }
    }
    return nil
}

