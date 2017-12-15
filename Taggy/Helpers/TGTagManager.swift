//
//  TagManager.swift
//  Taggy
//
//  Created by VirVit on 07/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class TGTagManager {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
    static func addTag(tagName: String,
                       tagValue: String? = nil,
                       tagUnit: String? = nil,
                       tagDescr: NSAttributedString? = nil) -> TGTag {
        let newTag = NSEntityDescription.insertNewObject(forEntityName: "TGTag",
                                                         into: moc) as! TGTag
        
        newTag.setValue(tagName, forKey: "tagName")
        newTag.setValue(tagValue, forKey: "tagValue")
        // FIXME add all attributes
        newTag.setValue(tagDescr, forKey: "tagDescr")
        
        appDelegate.saveContext()

        return newTag
    }
    
    // TODO Implement
    static func GetMostPopularTagNames(count: Int = 10) -> [String] {
        var tagNames: [String] = []
        
        // Initialize Fetch Request
        let tagFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TGTag")
        
        // Create Entity Description
        //let tagEntityDescription = NSEntityDescription.entity(forEntityName: "TGTag", in: moc)

        let keypathExp = NSExpression(forKeyPath: "tagName")
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType

        tagFetchRequest.fetchLimit = count
        tagFetchRequest.propertiesToFetch = ["tagName", countDesc]
        tagFetchRequest.propertiesToGroupBy = ["tagName"]
        tagFetchRequest.resultType = .dictionaryResultType
        
//        let sortDesc = NSSortDescriptor(key: "count", ascending: false)
//        tagFetchRequest.sortDescriptors = [sortDesc]

        do {
            let result = try moc.fetch(tagFetchRequest)  as! [NSDictionary]
            
            for record in result {
                tagNames.append(record["tagName"] as! String)
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
        return tagNames
    }
    
    // TODO Implement
    static func GetRecentlyUsedTags(count: Int = 10) -> [TGTag] {
        var tags: [TGTag] = []
        let tagFetchRequest: NSFetchRequest<TGTag> = TGTag.fetchRequest()
        tagFetchRequest.fetchLimit = count
        tagFetchRequest.returnsDistinctResults = true
        
        //        tagFetchRequest.predicate = NSPredicate(format: "(activityDate >= %@) AND (activityDate <= %@)",
        //                                                     dateFromCopy.startOfDay as NSDate,
        //                                                     dateFromCopy.endOfDay as NSDate)
        do {
            tags = try moc.fetch(tagFetchRequest) as [TGTag]
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }

        return tags
    }
}
