//
//  NSDateExt.swift
//  Taggy
//
//  Created by VirVit on 11/15/17.
//  Copyright © 2017 VirVit. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var nextDay: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: self)!
    }
    var prevDay: Date {
        var components = DateComponents()
        components.day = -1
        return Calendar.current.date(byAdding: components, to: self)!
    }

    var tgAsStringShort: String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-YYYY"
        
        return df.string(from: self)
    }
}
