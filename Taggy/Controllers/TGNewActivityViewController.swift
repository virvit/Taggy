//
//  TGNewActivityViewController.swift
//  Taggy
//
//  Created by VirVit on 25/10/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import CoreData
import DateTimePicker

// TODO Extend copy button with new modal view and options:
// FRom date, Last Used, Sets, Most Popular + copy values checkbox
class TGNewActivityViewController:    UIViewController,
    TagClickedDelegate
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
    var currentActivity: TGActivity?
    //var selectedTag: TGTag?

    @IBOutlet weak var tagUnit: UITextField!
    @IBOutlet weak var tagValue: UITextField!
    @IBOutlet weak var tagDescr: UITextView!
    
    @IBOutlet weak var tagList: TGTagListView!
    
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var currentDate: UITextField!

    @IBAction func copyTagsFromOtherDate(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        let formatter = self.getDateFormatter()
        let selectedDate = formatter.date(from: self.currentDate.text!) as Date?
        
        picker.selectedDate = selectedDate!.prevDay
        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            self.copyTagsFromDate(dateFromCopy: selectedDate!)
            self.appDelegate.saveContext()
            self.loadTagsFromDatabase()
        }
    }
    
    func copyTagsFromDate(dateFromCopy: Date) {
        // Initialize Fetch Request
        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        activityFetchRequest.predicate = NSPredicate(format: "(activityDate >= %@) AND (activityDate <= %@)",
                                                     dateFromCopy.startOfDay as NSDate,
                                                     dateFromCopy.endOfDay as NSDate)
        
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
                    newTag.addToActivities(self.currentActivity!)
                }
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
    }
    
    private func getDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        return formatter
    }
    
    @IBAction func clickPreviousDate(_ sender: UIButton) {
        let dateFormatter = getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.prevDay)
        
        appDelegate.saveContext()
        loadTagsFromDatabase()
    }
    
    @IBAction func clickNextDate(_ sender: UIButton) {
        let dateFormatter = self.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.nextDay)
        
        appDelegate.saveContext()
        loadTagsFromDatabase()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        appDelegate.saveContext()
    }
    
    @IBAction func startDataSelect(_ sender: UITextField) {
        // FIXME Glitch with date. In the evening chooses next day
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = self.getDateFormatter()
            self.currentDate.text = formatter.string(from: date)
            
            self.appDelegate.saveContext()
            self.loadTagsFromDatabase()
        }
    }
    
    @IBAction func addtag(_ sender: UIButton) {
        let newTagView = TGTagView()
        let newTag = NSEntityDescription.insertNewObject(forEntityName: "TGTag",
                                                         into: moc) as! TGTag

        if (tagName.text == "") {
            // Show error FIXME
        }
        else {
            newTagView.tagName = tagName.text!
            newTag.setValue(tagName.text!, forKey: "tagName")
        }

        if (tagValue.text == "") {
            // Show error FIXME
        }
        else {
            newTagView.tagValue = tagValue.text!
            newTag.setValue(tagValue.text!, forKey: "tagValue")
        }

        if (tagUnit.text == "") {
            // Show error FIXME
        }
        else {
            newTagView.tagUnit = tagUnit.text!
            // FIXME add reference to TGUnits
        }

        newTagView.tagId = newTag.objectID
        newTag.setValue(tagDescr.attributedText, forKey: "tagDescr")

        // FIXME Look for default tag with the same name to inherit appearance
        newTagView.delegate = self
        tagList.addTagView(tag: newTagView)
        
        newTag.addToActivities(self.currentActivity!)
        appDelegate.saveContext()
        
        // Clear fields for a new tag
        tagName.text = ""
        tagValue.text = ""
        tagUnit.text = ""
    }
    
    // Delegate
    
    func removeTagButtonClicked(tagView: TGTagView) {
        let tagId = tagView.tagId

        if !tagId.isTemporaryID {
            moc.delete(moc.object(with: tagId))
            appDelegate.saveContext()
        }
        
        tagList.removeTag(tagView: tagView)
    }

    // FIXME Allow only one tag to select
    func tagSelected(tagView: TGTagView) {
        let tagId = tagView.tagId
        
        let selectedTag = moc.object(with: tagId)
        
        tagName.text = selectedTag.value(forKey: "tagName") as? String
        tagValue.text = selectedTag.value(forKey: "tagValue") as? String
        
        //tagUnit.text =

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let dateFormatter = self.getDateFormatter()
        self.currentDate.text = dateFormatter.string(from: Date())
        // FIXME sets incorrect date when it's almost night time
        
        loadTagsFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadTagsFromDatabase() {
        // Steps
        // Find current day activity and load tags
        // If there is no activity for specified date, create a new activity
        self.tagList.removeAllTags()
        
        // Initialize Fetch Request
        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>()
       
        let dateFormatter = getDateFormatter()
        let currentDateAsDate = dateFormatter.date(from: self.currentDate.text!) as Date!
        
        activityFetchRequest.predicate = NSPredicate(format: "(activityDate >= %@) AND (activityDate <= %@)",
                                                     currentDateAsDate?.startOfDay as! NSDate,
                                                     currentDateAsDate?.endOfDay as! NSDate)

        // Create Entity Description
        let activityEntityDescription = NSEntityDescription.entity(forEntityName: "TGActivity", in: moc)
        
        // Configure Fetch Request
        activityFetchRequest.entity = activityEntityDescription
        
        do {
            self.currentActivity = try moc.fetch(activityFetchRequest).first as! TGActivity!

            if self.currentActivity != nil {
                print("Activity for ", self.currentDate.text!, " found in database")
                let tagListResult = self.currentActivity?.tags?.allObjects
                
                for case let tag as TGTag in tagListResult! {
                    let newTagView = TGTagView()
                    
                    if tag.tagName != nil {
                        newTagView.tagName = tag.tagName!
                    }
                    
                    if tag.tagValue != nil {
                        newTagView.tagValue = tag.tagValue!
                    }
                    
                    newTagView.tagId = tag.objectID
                    //print(tag.tagName!, " - ", tag.tagValue ?? "")
                    newTagView.delegate = self
                    tagList.addTagView(tag: newTagView)
                }
            }
            else {
                // Create empty activity
                print("No Activity found for ", self.currentDate.text!, " in database")
                self.currentActivity = (NSEntityDescription.insertNewObject(forEntityName: "TGActivity",
                                                                       into: moc) as! TGActivity)
                self.currentActivity!.setValue(currentDateAsDate, forKey: "activityDate")
                //moc.insert(self.currentActivity!)
            }
            
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
    }
    
}
