//
//  Number.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/29/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit
import Foundation

class Number: NSObject {
    
    class func formatToString(number: Int) -> String {
        let million = 1000000
        let thousand = 1000
        let formatted: String
        if (number > million){
            formatted = String(number / million) + "M"
        } else if (number > (10 * thousand)) {
            formatted = String(number / thousand) + "K"
        } else {
            formatted = String(number)
        }
        return formatted
    }
    
    class func formatDateToStandardString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
}
