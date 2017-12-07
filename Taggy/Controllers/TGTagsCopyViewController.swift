//
//  TGTagsCopyViewController.swift
//  Taggy
//
//  Created by VirVit on 07/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import CoreData
import DateTimePicker

// FIXME to do this
class TGTagsCopyViewController: UIViewController {
    var currentActivity: TGActivity?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
    @IBOutlet weak var currentDate: UITextField!
    
    @IBOutlet weak var recentlyUsedTagListView: TGTagListView!
    @IBOutlet weak var popularTagListView: TGTagListView!

    @IBAction func clickedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Recently used tags are 10 uniq tags used before today
    @IBAction func recentlyUsedClicked(_ sender: Any) {
        // Copy tags
        self.dismiss(animated: true, completion: nil)
    }
    
    // Popular tags are 10 tags mostly used
    @IBAction func popularClicked(_ sender: Any) {
        // Copy tags
        self.dismiss(animated: true, completion: nil)
    }

    
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
    }
    
    @IBAction func clickNextDate(_ sender: UIButton) {
        let dateFormatter = self.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.nextDay)
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
