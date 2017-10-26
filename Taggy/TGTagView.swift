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

@IBDesignable class TGTagView: UIControl {
    @IBInspectable var tagName: String = "" {
		didSet { setNeedsDisplay() }
	}

    @IBInspectable var tagUnit: String = "" {
		didSet { setNeedsDisplay() }
	}

    @IBInspectable var tagDescription: String = "" {
		didSet { setNeedsDisplay() }
	}

    @IBInspectable var tagValue: String = "" {
		didSet { setNeedsDisplay() }
	}

    @IBInspectable var tagDefaultValue: String = "" {
		didSet { setNeedsDisplay() }
	}

	@IBInspectable var tagColor: UIColor {
		didSet { setNeedsDisplay() }
	}

                                
	func drawRemoveButton(rect: CGRect, context: CGContext) {
        context.addEllipse(in: rect)
        context.setFillColor(UIColor.red.cgColor)
        context.closePath()
        context.fillPath()
    }
    
    func drawTagName(rect: CGRect, context: CGContext) {
        
        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: rect.width, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        
        let path = CGMutablePath()
        path.addRect(rect)
        
        let attrString = NSAttributedString(string: "Hello World")
        // 5
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        // 6
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        // 7
        CTFrameDraw(frame, context)
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let rectHeight: CGFloat = rect.height
        let rectWidth: CGFloat = rect.width
        let cornerRadius: CGFloat = rect.height / 3
        
        let centerX: CGFloat = (self.frame.width - rectWidth) / 2
        let centerY: CGFloat = (self.frame.height - rectHeight) / 2

        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        // Drawing code
        
        // Draw shape
        let rect = CGRect(x: centerX, y: centerY, width: rectWidth, height: rectHeight)
        
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        ctx.addPath(clipPath)
        ctx.setFillColor(UIColor.green.cgColor)
        ctx.closePath()
        ctx.fillPath()
        
        // Draw remove button
        let removeButtonMargin: CGFloat = rectHeight * 0.1
        let removeButtonSize: CGFloat = rectHeight - removeButtonMargin * 2
        let removeButtonRect: CGRect = CGRect(x: rectWidth - removeButtonMargin - removeButtonSize,
                                              y: removeButtonMargin,
                                              width: removeButtonSize,
                                              height: removeButtonSize)
        drawRemoveButton(rect: removeButtonRect, context: ctx)
        drawTagName(rect: rect, context: ctx)
        ctx.restoreGState()
    }

}
