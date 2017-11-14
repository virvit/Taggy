//
//  TGTag+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 13/11/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//
//

import Foundation
import CoreData


extension TGTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TGTag> {
        return NSFetchRequest<TGTag>(entityName: "TGTag")
    }

    @NSManaged public var tagColor: NSObject?
    @NSManaged public var tagDefaultValue: String?
    @NSManaged public var tagDescr: String?
    @NSManaged public var tagName: String?
    @NSManaged public var tagUnit: UUID?
    @NSManaged public var tagValue: String?
    @NSManaged public var activities: TGActivity?
    @NSManaged public var units: TGUnit?

}
