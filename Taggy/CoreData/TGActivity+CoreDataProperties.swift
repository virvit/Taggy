//
//  TGActivity+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 21/12/2017.
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
    @NSManaged public var activityDate: NSDate?
    @NSManaged public var activityNote: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension TGActivity {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TGTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TGTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
