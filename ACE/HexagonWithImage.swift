//
//  HexagonWithImage.swift
//  ARCE
//
//  Created by David Morrison on 14/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class HaxagonWithImage: UIView {
    @IBInspectable var image: UIImage?
    
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke()
        UIColor.blueColor().setFill()
        var path = bezierPathWithPolygonInRect(rect, 6, 0.3, -M_PI_2, 2)
        path.lineJoinStyle = kCGLineJoinRound
        path.lineWidth = 8.0
        path.addClip()
        if var img = image {
            img.drawInRect(rect)
        } else {
            path.fill()
        }
    }
}