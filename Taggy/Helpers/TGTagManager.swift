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
    
    // TODO Implement
    static func GetMostPopularTags(count: Int = 10) -> [TGTag] {
        var tags: [TGTag] = []
        
        let tagFetchRequest: NSFetchRequest = TGTag.fetchRequest()

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
        
        let sortDesc = NSSortDescriptor(key: "count", ascending: false)
        tagFetchRequest.sortDescriptors = [sortDesc]

        do {
            let result = try moc.fetch(tagFetchRequest)
            
            for r in result {
                let newTag = TGTag()
                newTag.tagName = r.tagName
                tags.append(newTag)
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
        return tags
    }
    
    // TODO Implement
    static func GetRecentlyUsedTags(count: Int = 10) -> [TGTag] {
        var tags: [TGTag] = []
        let tagFetchRequest: NSFetchRequest<TGTag> = TGTag.fetchRequest()
        tagFetchRequest.fetchLimit = count
        
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
