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

class TGNewActivityViewController:    UIViewController,
    TagClickedDelegate
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
    weak var currentActivity: TGActivity?
    weak var selectedTag: TGTag?

    @IBOutlet weak var tagUnit: UITextField!
    @IBOutlet weak var tagValue: UITextField!
    @IBOutlet weak var tagDescr: UITextView!
    
    @IBOutlet weak var tagList: TGTagListView!
    
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var currentDate: UITextField!

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
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = self.getDateFormatter()
            self.currentDate.text = formatter.string(from: date)
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

        newTag.setValue(tagDescr.attributedText, forKey: "tagDescr")

        // FIXME Look for default tag with the same name to inherit appearance
        newTagView.delegate = self
        tagList.addTagView(tag: newTagView)
        
        newTag.addToActivities(currentActivity!)
        appDelegate.saveContext()
        
        // Clear fields for a new tag
        tagName.text = ""
        tagValue.text = ""
        tagUnit.text = ""
    }
    
    // Delegate
    
    func removeTagButtonClicked(tagView: TGTagView) {
        // FIXME Remove tag from database
        tagList.removeTag(tagView: tagView)
        appDelegate.saveContext()
    }

    func tagSelected(tagView: TGTagView) {
        // FIXME
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

            if currentActivity != nil {
                let tagListResult = currentActivity?.tags?.allObjects
                
                for case let tag as TGTag in tagListResult! {
                    let newTagView = TGTagView()
                    
                    newTagView.tagName = tag.tagName!
                    
                    if tag.tagValue != nil {
                        newTagView.tagValue = tag.tagValue!
                    }
                    
                    //print(tag.tagName!, " - ", tag.tagValue ?? "")
                    newTagView.delegate = self
                    tagList.addTagView(tag: newTagView)
                }
            }
            else {
                // Create empty activity
                let dateFormatter = getDateFormatter()
                let currentDateAsDate = dateFormatter.date(from: self.currentDate.text!)

                currentActivity = (NSEntityDescription.insertNewObject(forEntityName: "TGActivity",
                                                                       into: moc) as! TGActivity)
                currentActivity!.setValue(currentDateAsDate, forKey: "activityDate")
                moc.insert(currentActivity!)
            }
            
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
        
    }
    
//    func addNewSpecialityButtonPressed(_ sender: DoctorSpecialityTableViewCell) {
//        // Cell is responsible to make speciality name editable
//        // We are responsible to create a new record next to the current
//
//        let newSpeciality = NSEntityDescription.insertNewObject(forEntityName: "Speciality",
//                                                                into: moc) as! Speciality
//
//        newSpeciality.setValue("New", forKey: "specialityName")
//
//        specialitiesArray.append(newSpeciality)
//
//        doctorSpecialities.reloadData()
//
//    }
}
