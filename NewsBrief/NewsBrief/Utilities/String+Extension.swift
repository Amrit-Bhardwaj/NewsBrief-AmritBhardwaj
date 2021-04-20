//
//  String+Extension.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd")-> Date? {

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            //dateFormatter.locale = Locale(identifier: "")
            dateFormatter.calendar = Calendar.current
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: self)

            return date

        }
    
    func toDateWithFormat(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        let date = dateFormatter.date(from: self)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let finalDate = calendar.date(from: components)
        return finalDate
    }
    
    /// Function to get date object from string
    ///
    /// - Parameters:
    ///
    ///   - format: Date format, defaults to nil. If no date format is specified then "yyyy-MM-dd'T'HH:mm:ssX" or "yyyy-MM-dd'T'HH:mm:ssXXXXX" or "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" format is used for conversion.
    ///   timeZone: This is a dummy parameter and it is not used inside this method and kept only for keeping the existing calling context intact.
    /// - Returns: date object

        public func date(withFormat format: String? = nil) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            var dateCreated:Date?
            
            if let formatStr = format {
                dateFormatter.dateFormat = formatStr
                dateCreated = dateFormatter.date(from: self)
                
            } else {
                
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
                dateCreated = dateFormatter.date(from: self)
                
                if(nil == dateCreated){
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                    dateCreated = dateFormatter.date(from: self)
                    
                    if(nil == dateCreated){
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
                        dateCreated = dateFormatter.date(from: self)
                    }
                }
            }

            return dateCreated
        }
}

