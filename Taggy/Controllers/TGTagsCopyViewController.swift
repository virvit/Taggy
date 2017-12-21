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

protocol TGCopyTagsDelegate {
    func addTagsAsACopy(tagNames: [String]) -> Void
}

class TGTagsCopyViewController: UIViewController,
                                TGTagClickedDelegate {
    
    var currentActivity: TGActivity?
    var delegate: TGCopyTagsDelegate?

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
        self.delegate?.addTagsAsACopy(tagNames: recentlyUsedTagListView.getTagNames())
        self.dismiss(animated: true, completion: nil)
    }
    
    // Popular tags are 10 tags mostly used
    @IBAction func popularClicked(_ sender: Any) {
        self.delegate?.addTagsAsACopy(tagNames: popularTagListView.getTagNames())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startDateSelect(_ sender: UITextField) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = TGDateUtils.getDateFormatter()
            self.currentDate.text = formatter.string(from: date)
        }
    }

    @IBAction func copyTagsFromOtherDate(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        let formatter = TGDateUtils.getDateFormatter()
        let selectedDate = formatter.date(from: self.currentDate.text!) as Date?
        
        picker.selectedDate = selectedDate!.prevDay
        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            TGTagManager.copyTagsToActivityFromDate(activityToCopy: self.currentActivity!, dateFrom: selectedDate!)
        }
    }
    
    func removeTagButtonClicked(tagView: TGTagView, sender: TGTagListView) {
        if sender == self.popularTagListView {
            self.popularTagListView.removeTag(tagView: tagView)
        }
        if sender == self.recentlyUsedTagListView {
            self.recentlyUsedTagListView.removeTag(tagView: tagView)
        }
    }
    
    @IBAction func clickPreviousDate(_ sender: UIButton) {
        let dateFormatter = TGDateUtils.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.prevDay)
    }
    
    @IBAction func clickNextDate(_ sender: UIButton) {
        let dateFormatter = TGDateUtils.getDateFormatter()
        let selectedDate: Date = dateFormatter.date(from: self.currentDate.text!) as Date!
        self.currentDate.text = dateFormatter.string(from: selectedDate.nextDay)
    }
    
    @IBAction func startDataSelect(_ sender: UITextField) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = true // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = TGDateUtils.getDateFormatter()
            self.currentDate.text = formatter.string(from: date)
        }
    }
    
    func tagSelected(tagView: TGTagView, sender: TGTagListView) {
        // <TODO: something?>
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormatter = TGDateUtils.getDateFormatter()
        self.currentDate.text = dateFormatter.string(from: Date())

        popularTagListView.delegate = self
        recentlyUsedTagListView.delegate = self
        
        // Fill view with popular tags
        let popularTags = TGTagManager.getMostPopularTagNames()
        for tagName in popularTags {
            let newTagView = self.popularTagListView.createNewTagView(tagName: tagName)
            self.popularTagListView.addTagView(tag: newTagView)
        }
        
        // Fill view with recent tags
        let recentTags = TGTagManager.getRecentlyUsedTagNames()
        for tagName in recentTags {
            let newTagView = self.recentlyUsedTagListView.createNewTagView(tagName: tagName)
            self.recentlyUsedTagListView.addTagView(tag: newTagView)
        }
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
