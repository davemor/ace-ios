//
//  HexagonView.swift
//  Hexagons
//
//  Created by David Morrison on 04/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

@IBDesignable class HexagonView: UIView {
    
    @IBInspectable var color: UIColor
    @IBInspectable var title: String?
    @IBInspectable var icon: String?
    @IBInspectable var fontSize: CGFloat = 20.0
    @IBInspectable var iconSize: CGFloat = 50.0
    
    // lookup table for the font awesome icons
    let icons = [
        "Calendar" : FontAwesome.Calendar,
        "Refresh" : FontAwesome.Refresh,
        "Users" : FontAwesome.Users,
        "Phone" : FontAwesome.Phone,
        "PencilSquareO" : FontAwesome.PencilSquareO,
        "Cog" : FontAwesome.Cog,
        "Cogs" : FontAwesome.Cogs,
        "FaEnvelopeO" : FontAwesome.EnvelopeO,
        "FaInfoCircle" : FontAwesome.InfoCircle
    ]
    
    // helpful constants
    let titleYPos: CGFloat = 0.75
    let iconYPos: CGFloat = 0.4
    let preferedFont = "Avenir Next Condensed"
    
    required init?(coder aDecoder: NSCoder) {
        color = UIColor.blueColor()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        color = UIColor.blueColor()
        super.init(frame: frame)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke()
        color.setFill()
        let path = bezierPathWithPolygonInRect(rect, numSides: 6, smooth: 0.3, startAngle: -M_PI_2, margin: 2)
        path.lineJoinStyle = CGLineJoin.Round
        path.lineWidth = 8.0
        path.fill()
        
        let center = CGPointMake(rect.size.width / 2, rect.size.height / 2)
        
        if let unwrapped = title {
            if let str = NSString(UTF8String: unwrapped) {

                let font = UIFont(name: preferedFont, size: fontSize) ?? UIFont.systemFontOfSize(fontSize)
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.Center
                let attrs = [
                    NSFontAttributeName: font,
                    NSParagraphStyleAttributeName: style,
                    NSForegroundColorAttributeName: UIColor.whiteColor()
                ]
                let textSize = str.sizeWithAttributes(attrs)
                let drawPoint = CGPointMake(
                    center.x - textSize.width / 2,
                    rect.size.height * titleYPos - textSize.height / 2)
                str.drawAtPoint(drawPoint, withAttributes: attrs)
            }
        }
        
        drawIcon(rect)
    }

    func drawIcon(rect: CGRect) {
        let font = UIFont.fontAwesomeOfSize(iconSize)
        if let _ = icon {
            if let t = icons[icon!] {
                let text = String.fontAwesomeIconWithName(t)
                let attributes = [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: UIColor.whiteColor()
                ]
                let size = text.sizeWithAttributes(attributes)
                let point = CGPointMake(
                    rect.size.width / 2 - size.width / 2,
                    rect.size.height * iconYPos - size.height / 2)
                if let string = NSString(UTF8String: text) {
                    string.drawAtPoint(point, withAttributes: attributes)
                }
            }
        }
    }
}

func bezierPathWithPolygonInRect(rect: CGRect, numSides: Int, smooth: Float, startAngle: Double, margin: CGFloat) -> UIBezierPath {
    assert(numSides >= 3, "Polygon cannot have less than 3 sides")
    
    let xRadius = CGRectGetWidth(rect) / 2 - margin
    let yRadius = CGRectGetHeight(rect) / 2 - margin
    
    let centerX = CGRectGetMidX(rect)
    let centerY = CGRectGetMidY(rect)
    
    let offset = 2 * M_PI / Double(numSides)
    
    let controlPoints = (0..<numSides).map { (i:Int) -> CGPoint in
        let theta = offset * Double(i) + startAngle
        let x = centerX + xRadius * CGFloat(cos(theta))
        let y = centerY + yRadius * CGFloat(sin(theta))
        return CGPoint(x: x, y: y)
    }
    
    let path = UIBezierPath()
    path.moveToPoint(controlPoints.first!)
    for point in controlPoints {
        path.addLineToPoint(point)
    }
    path.closePath()
    
    return path
}