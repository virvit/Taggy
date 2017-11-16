//
//  TGActivitiesViewController.swift
//  Taggy
//
//  Created by VirVit on 11/15/17.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import CoreData

class TGActivitiesViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext

    var arrayOfDates: [Date] = []
    var arrayOfActivities: [TGActivity] = []

    @IBOutlet weak var activityHistoryView: TGActivityHistory!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfActivities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        // return (arrayOfActivities[section].tags?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tagListView = TGTagListView(frame: cell.bounds)
        
        let tagListResult = arrayOfActivities[indexPath.section].tags?.allObjects
        
        for case let tag as TGTag in tagListResult! {
            let newTagView = TGTagView()
            
            if tag.tagName != nil {
                newTagView.tagName = tag.tagName!
            }
            
            if tag.tagValue != nil {
                newTagView.tagValue = tag.tagValue!
            }
            
//            newTagView.delegate = self
            tagListView.addTagView(tag: newTagView)
        }
        
        cell.addSubview(tagListView)
        
        //cell.textLabel?.text = (arrayOfActivities[indexPath.section].tags?.allObjects[indexPath.row] as! TGTag).tagName
        
        return cell
        
    }
    
    // Setup header for section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-YYYY"
        
        // return "Section " + String(section) + " " + df.string(from: arrayOfDates[section])
        return df.string(from: arrayOfActivities[section].activityDate as! Date)
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return CGFloat(10)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityHistoryView.delegate = self
        self.activityHistoryView.dataSource = self
        
        self.activityHistoryView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        LoadActivitiesFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("ran out of memory")
    }
    
    func LoadActivitiesFromDatabase() {
        // Initialize Fetch Request
        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let activityEntityDescription = NSEntityDescription.entity(forEntityName: "TGActivity", in: moc)
        
        // Configure Fetch Request
        activityFetchRequest.entity = activityEntityDescription
        let activitySortDescriptor = NSSortDescriptor(key: "activityDate", ascending: true)
        
        activityFetchRequest.sortDescriptors = [activitySortDescriptor]
        activityFetchRequest.predicate = NSPredicate(format: "tags.@count > 0")

        do {
            let activities = try moc.fetch(activityFetchRequest) as! [TGActivity]
            arrayOfActivities = activities
            
            for activity in activities {
                arrayOfDates.append(activity.activityDate! as Date)
            }
        } catch {
            let fetchError = error as NSError
            NSLog("fetchError: \(fetchError)")
        }
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
