//
//  TGActivitiesViewController.swift
//  Taggy
//
//  Created by VirVit on 11/15/17.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import CoreData

// TODO: Search
// TODO: Filter
// TODO: update view on core data changes
class TGActivitiesViewController: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate,
//                                    UISearchResultsUpdating,
//                                    UISearchBarDelegate,
                                    NSFetchedResultsControllerDelegate {
    
    let activityListCellIdentifier = "activityListCell"
    
    // let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let moc = (UIApplication.shared.delegate as! AppDelegate).getContext
    
//    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
//    var arrayOfDates: [Date] = []
//    var arrayOfActivities: [TGActivity] = []

    @IBOutlet weak var activityHistoryView: TGActivityHistory!

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<TGActivity> = {
        let fetchRequest: NSFetchRequest<TGActivity> = TGActivity.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "activityDate", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//        // return arrayOfActivities.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let activities = fetchedResultsController.fetchedObjects else { return 0 }
        return activities.count
        // return (arrayOfActivities[section].tags?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: activityListCellIdentifier, for: indexPath) as? TGActivityListCell else {
            fatalError("Unexpected Index Path")
        }
        
        let activity = fetchedResultsController.object(at: indexPath)
        cell.activityDate.text = activity.activityDate?.tgAsStringShort
        
        let tagsList = activity.tags
        
//        let tagListResult = arrayOfActivities[indexPath.section].tags?.allObjects
        
        for case let tag as TGTag in tagsList! {
            let newTagView = TGTagView()

            if tag.tagName != nil {
                newTagView.tagName = tag.tagName!
            }

            if tag.tagValue != nil {
                newTagView.tagValue = tag.tagValue!
            }

//            newTagView.delegate = self
            cell.activityTagsView.addTagView(tag: newTagView)
        }
        
//        cell.addSubview(tagListView)
//
        // cell.textLabel?.text = (arrayOfActivities[indexPath.section].tags?.allObjects[indexPath.row] as! TGTag).tagName
        
        return cell
        
    }
    
    // Setup header for section
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let df = DateFormatter()
//        df.dateFormat = "dd-MM-YYYY"
//
//        // return "Section " + String(section) + " " + df.string(from: arrayOfDates[section])
//        return df.string(from: arrayOfActivities[section].activityDate as Date!)
//    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return CGFloat(10)
    //    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activityHistoryView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        activityHistoryView.beginUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityHistoryView.delegate = self
        activityHistoryView.dataSource = self
        
        // self.activityHistoryView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add search
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.scopeButtonTitles = ["All", "Name", "Date"]
//        searchController.searchBar.delegate = self
//        definesPresentationContext = true
//
//        activityHistoryView.tableHeaderView = searchController.searchBar
//
//        loadActivitiesFromDatabase()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("ran out of memory")
    }
    
//    func loadActivitiesFromDatabase() {
//        // Initialize Fetch Request
//        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>()
//
//        // Create Entity Description
//        let activityEntityDescription = NSEntityDescription.entity(forEntityName: "TGActivity", in: moc)
//
//        // Configure Fetch Request
//        activityFetchRequest.entity = activityEntityDescription
//        let activitySortDescriptor = NSSortDescriptor(key: "activityDate", ascending: true)
//
//        activityFetchRequest.sortDescriptors = [activitySortDescriptor]
//        activityFetchRequest.predicate = NSPredicate(format: "tags.@count > 0")
//
//        do {
//            let activities = try moc.fetch(activityFetchRequest) as! [TGActivity]
//            arrayOfActivities = activities
//
//            for activity in activities {
//                arrayOfDates.append(activity.activityDate! as Date)
//            }
//        } catch {
//            let fetchError = error as NSError
//            NSLog("fetchError: \(fetchError)")
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
