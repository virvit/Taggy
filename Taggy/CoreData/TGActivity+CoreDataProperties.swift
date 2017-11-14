//
//  TGActivity+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 13/11/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//
//

import Foundation
import CoreData


extension TGActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TGActivity> {
        return NSFetchRequest<TGActivity>(entityName: "TGActivity")
    }

    @NSManaged public var activityAttachment: NSData?
    @NSManaged public var activityDay: NSDate?
    @NSManaged public var activityNote: String?
    @NSManaged public var tags: TGTag?

}
