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
    @IBInspectable var tagName: String = "Tag" {
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

	@IBInspectable var tagColor: UIColor = UIColor.black {
		didSet { setNeedsDisplay() }
	}

	func drawRemoveButton(rect: CGRect, context: CGContext) {
        
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
        
        let minusRectWidth:CGFloat = rect.height * 0.2
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
        path.move(to: CGPoint(x: minusRectFrame.minX, y: minusRectFrame.minY + minusRectFrame.height / 2 ))
        path.addLine(to: CGPoint(x: minusRectFrame.maxX, y: minusRectFrame.minY + minusRectFrame.height / 2))

        UIColor.white.setStroke()
        
        // Rotate
        path.apply(CGAffineTransform(translationX: minusRectFrame.midX, y: minusRectFrame.midY).inverted())
        path.apply(CGAffineTransform(rotationAngle: 45))
        path.apply(CGAffineTransform(translationX: minusRectFrame.midX, y: minusRectFrame.midY))
        path.stroke()
    }
    
    func drawTagName(rect: CGRect, context: CGContext) {
        let textFont: UIFont = UIFont(name: "Times New Roman", size: floor(rect.height / 2))!
        let aStringParams: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: textFont
        ]
        
        let attrString = NSAttributedString(string: tagName, attributes: aStringParams)
/*
        // Flip the coordinate system
        context.textMatrix = .identity
        //context.translateBy(x: 0, y: bounds.size.height)
        context.translateBy(x: rect.origin.x, y: rect.origin.y)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0, y: -( rect.origin.y + rect.size.height ) );
        
        //context.stroke(rect)
        
//        let textRect = CGRect(x: rect.minX,
//                              y: rect.minY,
//                              width: attrString.size().width,
//                              height: attrString.size().height)

        let textRect = CGRect(x: 0,
                              y: 50,
                              width: 150,
                              height: 120)

        //context.stroke(textRect)
        
        let path = CGMutablePath()
        path.addRect(rect)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        //let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        CTFrameDraw(frame, context)
*/
        let point: CGPoint = CGPoint(x: 15.0, y: rect.height / 2 - textFont.pointSize / 2)
        attrString.draw(at: point)
    }
    
    func drawValue(rect: CGRect, context: CGContext) {
        let textFont: UIFont = UIFont(name: "Times New Roman", size: floor(rect.height / 2))!
        let boldFont = UIFont(descriptor: textFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: textFont.pointSize)
        let aStringParams: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.orange,
            NSAttributedStringKey.font: boldFont
        ]
        
        let attrString = NSAttributedString(string: self.tagValue, attributes: aStringParams)

        let point: CGPoint = CGPoint(x: rect.width / 2, y: rect.height / 2 - boldFont.pointSize / 2)
        print(rect.height)
        attrString.draw(at: point)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let rectWidth: CGFloat = rect.width
        let rectHeight: CGFloat = rect.height
        let cornerRadius: CGFloat = rect.height / 3
        let controlsMargin: CGFloat = rectHeight * 0.1
        
        let centerX: CGFloat = (self.frame.width - rectWidth) / 2
        let centerY: CGFloat = (self.frame.height - rectHeight) / 2

        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        tagValue = "10.3"

        // Drawing code
        // 50% - label
        // 30% - value, unit, comments
        // 20% - remove button
        
        // Draw shape (rounded rectangle)
        let rect = CGRect(x: centerX, y: centerY, width: rectWidth, height: rectHeight)
        
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        ctx.addPath(clipPath)
        ctx.setFillColor(UIColor(red: CGFloat(57.0/255.0),
                                 green: CGFloat(181.0/255.0),
                                 blue: CGFloat(74.0/255.0),
                                 alpha: 1.0).cgColor)
        ctx.closePath()
        ctx.fillPath()
        drawValue(rect: rect, context: ctx)
        // Draw remove button
        
        let removeButtonSize: CGFloat = rectHeight - controlsMargin * 2
        let removeButtonRect: CGRect = CGRect(x: rectWidth - controlsMargin - removeButtonSize,
                                              y: controlsMargin,
                                              width: removeButtonSize,
                                              height: removeButtonSize)
        drawRemoveButton(rect: removeButtonRect, context: ctx)
        
        let tagNameRect = CGRect(x: cornerRadius,
                                 y: controlsMargin,
                                 width: rect.width / 2,
                                 height: rect.height - controlsMargin * 2)
        
        drawTagName(rect: tagNameRect, context: ctx)
        
        
        ctx.restoreGState()
    }
}
