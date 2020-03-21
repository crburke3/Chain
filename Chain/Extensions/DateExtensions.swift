//
//  DateExtensions.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation

extension Date{
    func timeTillDeath()->String{
        let extraTime = self.timeIntervalSince(Date())
        let time = NSInteger(extraTime)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600) % 24
        var finalString = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        let calInterval = Calendar.current.dateComponents([.day], from: Date(), to: self)
        let days = calInterval.day ?? 0
        let months = calInterval.month ?? 0
        let years = calInterval.year ?? 0
        if days > 0{
            finalString = "\(days) days \(finalString)"
        }
        if months > 0{
            finalString = "\(months) months \(finalString)"
        }
        if years > 0{
            finalString = "\(years) years \(finalString)"
        }
        return finalString
    }
    
    func timeTillDeath(timeLeft: @escaping (String)->()){
        //Runs every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let finalString = self.timeTillDeath()
            DispatchQueue.main.async {
                timeLeft(finalString)
            }
        }
    }
}
