//
//  TGTagListView.swift
//  Taggy
//
//  Created by VirVit on 06/11/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit

@IBDesignable open class TGTagListView: UIView {
    
    private var arrayOfTags: [TGTagView] = []

    @IBInspectable public var tagMargin: CGFloat = CGFloat(5) {
        didSet {
            setNeedsDisplay()
        }
    }

    public func removeTag(tagView: TGTagView) {
        let i: Int = arrayOfTags.index(of: tagView)!
        arrayOfTags.remove(at: i)
        
        rearrangeViews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        rearrangeViews()
    }
    
    // Keep all views to be able to remove them quickly for redraw
    private var rowViews: [UIView] = []
    private var tagViews: [TGTagView] = []
    
    private func rearrangeViews() {
        let rowMaxSize = self.frame.width
        
        var currentRow: Int = 0
        var occupiedRowSize = CGFloat(0)

        for v in tagViews as [TGTagView] {
            v.removeFromSuperview()
        }
        
        rowViews.removeAll(keepingCapacity: true)
        var rowView = UIView()

        for (_, tagView) in arrayOfTags.enumerated() {
            let tagWidth: CGFloat = tagView.frame.width
            let tagHeight: CGFloat = tagView.frame.height
            
            // Add new row
            if ((occupiedRowSize + tagWidth + tagMargin) > rowMaxSize) {
                // Show current row in view
                rowView.frame.size.width = rowMaxSize

                rowView.frame.origin.x = tagMargin
                rowView.frame.origin.y = CGFloat(currentRow) * tagHeight // FIXME

                rowViews.append(rowView)
                addSubview(rowView)

                // Initialize a new row
                occupiedRowSize = 0
                rowView = UIView()
                
                currentRow += 1
            }
                
            // Set row size dimensions
            rowView.frame.size.width = rowMaxSize
            rowView.frame.size.height = max(tagHeight, rowView.frame.height)
            
            // Set tag position in a row
            tagView.frame.origin.x = occupiedRowSize + tagMargin

            // Add tag to the current row
            tagViews.append(tagView)
            rowView.addSubview(tagView)
            occupiedRowSize += tagWidth + tagMargin
        }

        // Show current/last row in view
        rowView.frame.size.width = rowMaxSize
        
        rowView.frame.origin.x = tagMargin
        rowView.frame.origin.y = CGFloat(currentRow) * 30 // FIXME
        
        addSubview(rowView)
        rowViews.append(rowView)

        invalidateIntrinsicContentSize()
    }

//    override open var intrinsicContentSize: CGSize {
////        var height = CGFloat(rows) * (tagViewHeight + marginY)
////        if rows > 0 {
////            height -= marginY
////        }
//        return CGSize(width: frame.width, height: height)
//    }
    
    open func addTagView(tag: TGTagView) {
        arrayOfTags.append(tag)
        
        rearrangeViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        let demoTag1 = TGTagView()
        demoTag1.tagName = "Welcome"
        arrayOfTags.append(demoTag1)

        let demoTag2 = TGTagView()
        demoTag2.tagName = "Tag 2"
        demoTag2.tagValue = "14"
        demoTag2.tagUnit = "Miles"
        arrayOfTags.append(demoTag2)

        let demoTag3 = TGTagView()
        demoTag3.tagName = "Welcome 3"
        arrayOfTags.append(demoTag3)

        rearrangeViews()
        invalidateIntrinsicContentSize()
    }
}
