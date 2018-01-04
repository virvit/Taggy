//
//  TGTagView.swift
//  Taggy
//
//  Created by VirVit on 25/10/2017.
//  Copyright © 2017 VirVit. All rights reserved.
//

import UIKit
import QuartzCore
import CoreText
import CoreData

protocol TGTagClickedDelegate {
    func removeTagButtonClicked(tagView: TGTagView, sender: TGTagListView) -> Void
    func tagSelected(tagView: TGTagView, sender: TGTagListView) -> Void
}

protocol TGTagViewClickedDelegate {
    func removeTagButtonClicked(tagView: TGTagView) -> Void
    func tagSelected(tagView: TGTagView) -> Void
}

@IBDesignable open class TGTagView: UIButton, UIGestureRecognizerDelegate {
    private var removeButtonSize: CGFloat = CGFloat()
    private var removeButtonRect: CGRect = CGRect()
    var tagId: NSManagedObjectID = NSManagedObjectID()
    
    var delegate: TGTagViewClickedDelegate?
    
    @IBInspectable public var tagName: String = "Tag" {
        didSet {
            setupView()
            setNeedsDisplay()
        }
	}

    @IBInspectable public var tagUnit: String = "" {
        didSet {
            setupView()
            setNeedsDisplay()
        }
	}

    @IBInspectable public  var tagDescription: String = "" {
		didSet {
            setNeedsDisplay()
        }
	}

    @IBInspectable public var tagValue: String = "" {
        didSet {
            setupView()
            setNeedsDisplay()
        }
	}

    @IBInspectable public var tagDefaultValue: String = "" {
		didSet {
            setNeedsDisplay()
        }
	}

	@IBInspectable public var tagColor: UIColor = UIColor.black {
		didSet {
            setNeedsDisplay()
        }
	}

    @IBInspectable public var tagNameFont: UIFont = UIFont(name: "Times New Roman", size: 12)! {
        didSet {
            setupView()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var tagValueFont: UIFont = UIFont(name: "Times New Roman", size: 10)! {
        didSet {
            setupView()
            setNeedsDisplay()
        }
    }

//    @IBInspectable public var cornerRadius: CGFloat = 10 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }

    @IBInspectable public var controlsMargin: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        tagName = "My tag"
        tagValue = "10.3"
        tagUnit = "Miles"
    }
    
    private func drawTagShape(rect: CGRect, context: CGContext) {
        // Draw shape (rounded rectangle)
//        let centerX: CGFloat = (self.frame.width - rect.width) / 2
//        let centerY: CGFloat = (self.frame.height - rect.height) / 2

        // let rect = CGRect(x: centerX, y: centerY, width: rect.width, height: rect.height)
        
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        context.addPath(clipPath)
        
        if isSelected {
            context.setFillColor(UIColor(red: CGFloat(7.0/255.0),
                                         green: CGFloat(18.0/255.0),
                                         blue: CGFloat(50.0/255.0),
                                         alpha: 1.0).cgColor)
        }
        else {
//            context.setFillColor(UIColor(red: CGFloat(57.0/255.0),
//                                         green: CGFloat(181.0/255.0),
//                                         blue: CGFloat(74.0/255.0),
//                                         alpha: 1.0).cgColor)
            context.setFillColor(UIColor.white.cgColor)
            UIColor.black.setStroke()
            

        }
        context.closePath()
        context.fillPath()
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).stroke()

    }
    
    private func drawTagName(rect: CGRect, context: CGContext) {
        let aStringParams: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: tagNameFont
        ]
        
        let tagNameString = NSAttributedString(string: tagName, attributes: aStringParams)
        let point: CGPoint = CGPoint(x: rect.minX, y: rect.height / 2 - tagNameFont.pointSize / 2)
        tagNameString.draw(at: point)
    }
    
    private func drawTagValue(rect: CGRect, context: CGContext) {
        // Draw units under value
        // Value
        // Units
        
        let aStringParams: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.orange,
            NSAttributedStringKey.font: tagValueFont
        ]

        var yPoint = CGFloat(0)

        let valueString = NSAttributedString(string: self.tagValue, attributes: aStringParams)
        valueString.draw(at: CGPoint(x: rect.minX, y: yPoint))
        
        if tagUnit != "" {
            yPoint += tagValueFont.pointSize
            let unitString = NSAttributedString(string: tagUnit, attributes: aStringParams)
            unitString.draw(at: CGPoint(x: rect.minX, y: yPoint))
        }

    }
    
    private func drawRemoveButton(rect: CGRect, context: CGContext) {
        
        // Draw circle
        context.addEllipse(in: rect)
        context.setFillColor(UIColor(red: CGFloat(0.0/255.0),
                                     green: CGFloat(166.0/255.0),
                                     blue: CGFloat(81.0/255.0),
                                     alpha: 1.0).cgColor)
        context.closePath()
        context.fillPath()
        
        // Draw cross lines inside the circle
        let path = UIBezierPath()
        
        let minusRectWidth: CGFloat = rect.height * 0.2
        path.lineWidth = rect.height * 0.15
        path.lineCapStyle = .round
        
        let minusRectFrame = CGRect(x: rect.minX + minusRectWidth,
                                    y: rect.minY + minusRectWidth,
                                    width: rect.width - minusRectWidth * 2,
                                    height: rect.height - minusRectWidth * 2)
        
        // Vertical
        path.move(to: CGPoint(x: minusRectFrame.minX + minusRectFrame.width / 2, y: minusRectFrame.minY))
        path.addLine(to: CGPoint(x: minusRectFrame.minX + minusRectFrame.width / 2, y: minusRectFrame.maxY))
        // Horizontal
        path.move(to: CGPoint(x: minusRectFrame.minX, y: minusRectFrame.minY + minusRectFrame.height / 2))
        path.addLine(to: CGPoint(x: minusRectFrame.maxX, y: minusRectFrame.minY + minusRectFrame.height / 2))
        
        UIColor.white.setStroke()
        
        // Rotate
        path.apply(CGAffineTransform(translationX: minusRectFrame.midX, y: minusRectFrame.midY).inverted())
        path.apply(CGAffineTransform(rotationAngle: 45))
        path.apply(CGAffineTransform(translationX: minusRectFrame.midX, y: minusRectFrame.midY))
        path.stroke()
    }
    
    override open func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()

        // Drawing code
        // 60% - label
        // 30% - value, unit, comments
        // 10% - remove button
        
        drawTagShape(rect: rect, context: context)

        if tagValue != "" {
            let tagNameRect = CGRect(x: rect.minX + controlsMargin,
                                     y: controlsMargin,
                                     width: getTagNameWidth(),
                                     height: self.frame.height - controlsMargin * 2)

            let tagValueRect = CGRect(x: tagNameRect.maxX + controlsMargin,
                                     y: controlsMargin,
                                     width: getTagValueWidth(),
                                     height: self.frame.height - controlsMargin * 2)
            
//            let bpath:UIBezierPath = UIBezierPath(rect: tagNameRect)
//
//            UIColor.yellow.set()
//            bpath.stroke()
            
            drawTagName(rect: tagNameRect, context: context)
            drawTagValue(rect: tagValueRect, context: context)
        }
        else {
            let tagNameRect = CGRect(x: rect.minX + controlsMargin,
                                     y: controlsMargin,
                                     width: getTagNameWidth(),
                                     height: self.frame.height - controlsMargin * 2)
            drawTagName(rect: tagNameRect, context: context)
        }

        // Draw remove button
        removeButtonRect = CGRect(x: self.frame.width - controlsMargin - removeButtonSize,
                                              y: controlsMargin,
                                              width: removeButtonSize,
                                              height: removeButtonSize)
        
        drawRemoveButton(rect: removeButtonRect, context: context)
        
        context.restoreGState()
    }
    
    private func getTagNameWidth() -> CGFloat {
        return tagName.size(withAttributes: [NSAttributedStringKey.font: tagNameFont]).width
    }
    
    private func getTagValueWidth() -> CGFloat {
        let tagValueSize = tagValue.size(withAttributes: [NSAttributedStringKey.font: tagValueFont])
        let tagUnitsSize = tagUnit.size(withAttributes: [NSAttributedStringKey.font: tagValueFont])
        
        return  max(tagValueSize.width, tagUnitsSize.width)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public init(tagName: String) {
        super.init(frame: CGRect.zero)
        self.tagName = tagName
        
        setupView()
    }
    
    override open var intrinsicContentSize: CGSize {
        var frameSize: CGSize = CGSize()
        
        let tagNameSize = tagName.size(withAttributes: [NSAttributedStringKey.font: tagNameFont])
        var tagValueSize = tagValue.size(withAttributes: [NSAttributedStringKey.font: tagValueFont])
        let tagUnitsSize = tagUnit.size(withAttributes: [NSAttributedStringKey.font: tagValueFont])
        
        tagValueSize.width = max(tagValueSize.width, tagUnitsSize.width)
        tagValueSize.height = tagValueSize.height + tagUnitsSize.height

        let maxHeight = max(tagNameSize.height, tagValueSize.height)

        if cornerRadius == 0 {
            cornerRadius = maxHeight / 3
        }
        
        if controlsMargin == 0 {
            controlsMargin = maxHeight * 0.1
        }
        
        frameSize.height = controlsMargin * 2 + maxHeight
        removeButtonSize = maxHeight

        frameSize.height = controlsMargin * 2 + max(tagNameSize.height, tagValueSize.height)
        frameSize.width = controlsMargin * 4 + tagNameSize.width + tagValueSize.width + removeButtonSize

        return frameSize
    }
    
    private func setupView() {
        frame.size = intrinsicContentSize
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickTag))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func clickTag(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint: CGPoint = gestureRecognizer.location(in: self)
        
        if removeButtonRect.contains(tapPoint) {
            delegate?.removeTagButtonClicked(tagView: self)
        }
        else {
            isSelected = !isSelected
            delegate?.tagSelected(tagView: self)
        }
    }
    
}
