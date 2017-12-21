//
//  TGUnit+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 21/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//
//

import Foundation
import CoreData


extension TGUnit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TGUnit> {
        return NSFetchRequest<TGUnit>(entityName: "TGUnit")
    }

    @NSManaged public var unitName: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension TGUnit {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TGTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TGTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
