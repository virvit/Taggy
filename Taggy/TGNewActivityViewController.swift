//
//  TGNewActivityViewController.swift
//  Taggy
//
//  Created by VirVit on 25/10/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import CoreData

class TGNewActivityViewController:    UIViewController,
    RemoveTagDelegate
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext

    @IBOutlet weak var tagUnit: UITextField!
    @IBOutlet weak var tagValue: UITextField!
    
    @IBOutlet weak var tagList: TGTagListView!
    
    @IBOutlet weak var tagName: UITextField!
    
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

        // FIXME Look for default tag with the same name to inherit appearance
        newTagView.delegate = self
        tagList.addTagView(tag: newTagView)
        
        do {
            try moc.save()
        } catch _ {
            print("Something went wrong during saving tag to database")
        }
        
        // Clear fields for a new tag
        tagName.text = ""
        tagValue.text = ""
        tagUnit.text = ""
    }
    
    func removeTagButtonClicked(tagView: TGTagView) {
        // FIXME Remove tag from database
        tagList.removeTag(tagView: tagView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadTagsFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTagsFromDatabase() {
        // Initialize Fetch Request
        let tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let tagNameSort = NSSortDescriptor(key: "tagName", ascending: true)
        tagsFetchRequest.sortDescriptors = [tagNameSort]
        
        // Create Entity Description
        let tagEntityDescription = NSEntityDescription.entity(forEntityName: "TGTag", in: moc)
        
        // Configure Fetch Request
        tagsFetchRequest.entity = tagEntityDescription
        
        do {
            let tagListResult = try moc.fetch(tagsFetchRequest)
            print("Found %& tags", tagListResult.count)
            
            for tag in tagListResult as! [TGTag] {
                let newTagView = TGTagView()
                
                newTagView.tagName = tag.tagName!
                
                if tag.tagValue != nil {
                    newTagView.tagValue = tag.tagValue!
                }
                
                newTagView.delegate = self
                tagList.addTagView(tag: newTagView)
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
