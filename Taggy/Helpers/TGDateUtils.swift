//
//  TGDateUtils.swift
//  Taggy
//
//  Created by VirVit on 14/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import Foundation

class TGDateUtils {
    let TGDateStorageFormat = "dd-mm-YYYY"
    
    static func getDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        return formatter
    }
}
