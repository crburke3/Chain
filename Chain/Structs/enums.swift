//
//  enums.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation

//Used as easy ways to save Strings and stuff to the phone
enum SaveKeys:String{
    case username
    case password
    case phoneNumber
    
}

enum LoadState:String{
    case NOT_LOADED
    case LOADING
    case LOADED
}

enum FirestorePath:String{
    case GENERAL
    case GLOBAL
}
