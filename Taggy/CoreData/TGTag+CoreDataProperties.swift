//
//  TGTag+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 21/12/2017.
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
    @NSManaged public var tagDescr: NSObject?
    @NSManaged public var tagName: String?
    @NSManaged public var tagUnit: UUID?
    @NSManaged public var tagValue: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var activities: NSSet?
    @NSManaged public var units: TGUnit?

}

// MARK: Generated accessors for activities
extension TGTag {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: TGActivity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: TGActivity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}
