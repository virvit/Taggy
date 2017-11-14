//
//  TGUnit+CoreDataProperties.swift
//  Taggy
//
//  Created by VirVit on 13/11/2017.
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
    @NSManaged public var tags: TGTag?

}
