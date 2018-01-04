//
//  TGActivityExt.swift
//  Taggy
//
//  Created by VirVit on 21/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import Foundation

extension TGActivity {
    
    override public func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: "createdAt")
    }
    
    override public func willSave() {
        if let updatedAt = updatedAt {
            if updatedAt.timeIntervalSince(Date()) > 10.0 {
                self.updatedAt = Date()
            }
            
        } else {
            self.updatedAt = Date()
        }
    }

}
