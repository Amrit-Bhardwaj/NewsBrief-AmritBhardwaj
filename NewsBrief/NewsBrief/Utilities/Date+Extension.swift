//
//  Date+Extension.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

extension Date {
    
    /// This method is for converting date to local time
    ///
    /// - Returns: local equivalent of the date on which operated
    func convertToLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// This method is used for ignoring the hr, min, sec component of date
    ///
    /// - Returns: Date
    func effectiveCurrentDate() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let finalDate = calendar.date(from: components)!
        return finalDate
    }
}
