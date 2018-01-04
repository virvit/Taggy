//
//  TGActivityListCell.swift
//  Taggy
//
//  Created by VirVit on 28/12/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit

@IBDesignable class TGActivityListCell: UITableViewCell {

    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityTagsView: TGTagListView!

    open override func prepareForInterfaceBuilder() {
//        let dateFormatter = TGDateUtils.getDateFormatter()
//        self.activityDate.text = dateFormatter.string(from: Date())
//        activityDate.text = "Hi"
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
