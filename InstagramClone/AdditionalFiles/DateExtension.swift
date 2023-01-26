//
//  DateExtension.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 2.10.2022.
//

import Foundation


extension Date {
    
    func dateExpression() -> String {
        
        
        
        let second = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60*minute
        let day = 24*hour
        let week = 7*day
        let month = 4*week
        let year = 12*month
        
        
        let rate : Int
        let unit : String
        
       // let logInID = userID == "" ? validateduserID : userID
        
        
        if second < minute {
            rate = second
            unit = "seconds"
        } else if second < hour {
            rate = second / minute
            if rate == 1 {unit = "minute"} else {unit = "minutes"}
        } else if second < day {
            rate = second / hour
            if rate == 1 {unit = "hour"} else {unit = "hours"}
        } else if second < week {
            rate = second / day
            if rate == 1 {unit = "day"} else {unit = "days"}
        } else if second < month {
            rate = second / week
            if rate == 1 {unit = "week"} else {unit = "weeks"}
        } else {
            rate = second / month
            if rate == 1 {unit = "month"} else {unit = "months"}
            }
        
        
        return "\(rate) \(unit) ago"
        
    }
    
    
    
    
}
