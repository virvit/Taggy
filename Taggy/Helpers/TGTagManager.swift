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
    
    static func addTagsToActivity(activity: TGActivity, tagNames: [String]) {
        tagNames.forEach { (tagName) in
            let newtag = addTag(tagName: tagName)
            newtag.addToActivities(activity)
        }
        
        appDelegate.saveContext()
    }
    
    static func copyTagsToActivityFromDate(activityToCopy: TGActivity, dateFrom: Date) {
        // Initialize Fetch Request
        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        activityFetchRequest.predicate = NSPredicate(format: "(activityDate >= %@) AND (activityDate <= %@)",
                                                     dateFrom.startOfDay as NSDate,
                                                     dateFrom.endOfDay as NSDate)
        
        // Create Entity Description
        let activityEntityDescription = NSEntityDescription.entity(forEntityName: "TGActivity", in: moc)
        let tagEntityDescription = NSEntityDescription.entity(forEntityName: "TGTag", in: moc)
        
        // Configure Fetch Request
        activityFetchRequest.entity = activityEntityDescription
        
        do {
            let selectedDayActivity = try moc.fetch(activityFetchRequest).first as! TGActivity!
            
            if selectedDayActivity != nil {
                let tagListResult = selectedDayActivity?.tags?.allObjects
                
                for case let tag as TGTag in tagListResult! {
                    
                    let newTag = NSEntityDescription.insertNewObject(forEntityName: "TGTag",
                                                                     into: moc) as! TGTag
                    
                    let tagProperties = tagEntityDescription?.attributesByName
                    
                    for case let tagPropertyName in tagProperties! {
                        let val = tag.value(forKey: tagPropertyName.key)
                        newTag.setValue(val, forKey: tagPropertyName.key)
                    }
                    newTag.addToActivities(activityToCopy)
                }
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
        appDelegate.saveContext()
    }
    
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
    
    // TODO: Implement sorting by count
    static func getMostPopularTagNames(count: Int = 10) -> [String] {
        var tagNames: [String] = []
        
        // Initialize Fetch Request
        let tagFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TGTag")
        
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
            let result = try moc.fetch(tagFetchRequest) as! [NSDictionary]
            
            for record in result {
                tagNames.append(record["tagName"] as! String)
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
        return tagNames
    }
    
    static func getRecentlyUsedTagNames(count: Int = 10) -> [String] {
        var tagNames: [String] = []
        let tagFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TGTag")
        
        tagFetchRequest.fetchLimit = count
        tagFetchRequest.returnsDistinctResults = true
        tagFetchRequest.propertiesToFetch = ["tagName"]
        tagFetchRequest.resultType = .dictionaryResultType
        
        do {
            let result = try moc.fetch(tagFetchRequest) as! [NSDictionary]
            
            for record in result {
                tagNames.append(record["tagName"] as! String)
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }

        return tagNames
    }
    
}
