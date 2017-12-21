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

class TGNewActivityViewController : UIViewController,
    TGTagClickedDelegate,
    TGCopyTagsDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
    var currentActivity: TGActivity?

    @IBOutlet weak var tagUnit: UITextField!
    @IBOutlet weak var tagValue: UITextField!
    @IBOutlet weak var tagDescr: UITextView!
    
    @IBOutlet weak var tagList: TGTagListView!
    
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var currentDate: UITextField!

    @IBAction func copyTagsFromOtherDate(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        let formatter = TGDateUtils.getDateFormatter()
        let selectedDate = formatter.date(from: self.currentDate.text!) as Date?
        
        picker.selectedDate = selectedDate!.prevDay
        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            TGTagManager.copyTagsToActivityFromDate(activityToCopy: self.currentActivity!, dateFrom: selectedDate!)
            self.loadTagsFromDatabase()
        }
    }
    
    @IBAction func clickPreviousDate(_ sender: UIButton) {
        let dateFormatter = TGDateUtils.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.prevDay)
        
        appDelegate.saveContext()
        loadTagsFromDatabase()
    }
    
    @IBAction func clickNextDate(_ sender: UIButton) {
        let dateFormatter = TGDateUtils.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.nextDay)
        
        appDelegate.saveContext()
        loadTagsFromDatabase()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        appDelegate.saveContext()
    }
    
    @IBAction func startDataSelect(_ sender: UITextField) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = TGDateUtils.getDateFormatter()
            self.currentDate.text = formatter.string(from: date)
            self.loadTagsFromDatabase()
        }
    }
    
    func initNewTagFields() {
        // Clear fields for a new tag
        tagName.text = "New tag"
        tagValue.text = ""
        tagUnit.text = ""
    }
    
    // FIXMI add all other fields
    func initFieldsWithTag(tag: NSManagedObject) {
        tagName.text = tag.value(forKey: "tagName") as? String
        tagValue.text = tag.value(forKey: "tagValue") as? String
        
        // tagUnit.text =
    }
    
    @IBAction func addtag(_ sender: UIButton) {
        let newTag = TGTagManager.addTag(tagName: tagName.text!,
                                         tagValue: tagValue?.text,
                                         tagUnit: nil,
                                         tagDescr: tagDescr?.attributedText)

        let newTagView = tagList.createNewTagView(tagName: tagName.text!,
                                                  tagValue: tagValue?.text,
                                                  tagUnit: nil)

        newTagView.tagId = newTag.objectID

        // <TODO: Look for default tag with the same name to inherit appearance>
        tagList.addTagView(tag: newTagView)
        
        newTag.addToActivities(self.currentActivity!)
        initNewTagFields()
    }
    
    // Delegate
    
    func removeTagButtonClicked(tagView: TGTagView, sender: TGTagListView) {
        let tagId = tagView.tagId

        if !tagId.isTemporaryID {
            moc.delete(moc.object(with: tagId))
            appDelegate.saveContext()
        }
        
        tagList.removeTag(tagView: tagView)
    }

    // FIXME Allow only one tag to select
    func tagSelected(tagView: TGTagView, sender: TGTagListView) {
        let tagId = tagView.tagId
        
        let selectedTag = moc.object(with: tagId)
        
        initFieldsWithTag(tag: selectedTag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let dateFormatter = TGDateUtils.getDateFormatter()
        self.currentDate.text = dateFormatter.string(from: Date())
        
        tagList.delegate = self
        
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
       
        let dateFormatter = TGDateUtils.getDateFormatter()
        let currentDateAsDate = dateFormatter.date(from: self.currentDate.text!) as Date!
        
        activityFetchRequest.predicate = NSPredicate(format: "(activityDate >= %@) AND (activityDate <= %@)",
                                                     currentDateAsDate?.startOfDay as CVarArg!,
                                                     currentDateAsDate?.endOfDay as CVarArg!)

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
                    tagList.addTagView(tag: newTagView)
                }
            }
            else {
                // Create empty activity
                print("No Activity found for ", self.currentDate.text!, " in database")
                self.currentActivity = (NSEntityDescription.insertNewObject(forEntityName: "TGActivity",
                                                                       into: moc) as! TGActivity)
                self.currentActivity!.setValue(currentDateAsDate, forKey: "activityDate")
                // moc.insert(self.currentActivity!)
            }
            
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CopyTagsSegue" {
            let vc = segue.destination as! TGTagsCopyViewController
            vc.currentActivity = currentActivity
            vc.delegate = self
        }
    }
    
    func addTagsAsACopy(tagNames: [String]) {
        TGTagManager.addTagsToActivity(activity: currentActivity!, tagNames: tagNames)
        loadTagsFromDatabase()
    }
    
}
