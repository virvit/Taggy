//
//  ViewController.swift
//  Taggy
//
//  Created by VirVit on 25/10/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit

class ViewController:    UIViewController
{
    //var arrayOfTags: [TGTagView] = []

    @IBOutlet weak var tagList: TGTagListView!
    
    @IBOutlet weak var tagName: UITextField!
    @IBAction func addtag(_ sender: UIButton) {
        tagList.addTagView(tag: TGTagView(tagName: tagName.text!))
        
        //arrayOfTags.append(tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
