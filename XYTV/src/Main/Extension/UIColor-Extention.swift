//
//  UIColor-Extention.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/26.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r : CGFloat, g :CGFloat, b :CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    convenience init?(hex : String, alpha : CGFloat = 1.0) {
        guard hex.count >= 6  else {
            return nil
        }
        
        var temphex = hex.uppercased()
        
        if temphex.hasPrefix("##") || temphex.hasPrefix("0x") {
            temphex = (temphex as NSString).substring(from: 2)
        }
        if temphex.hasPrefix("#") {
            temphex = (temphex as NSString).substring(from: 1)
        }
        
        var range = NSMakeRange(0, 2)
        let rhex = (temphex as NSString).substring(with: range)
        range.location = 2
        let ghex = (temphex as NSString).substring(with: range)
        range.location = 4
        let bhex = (temphex as NSString).substring(with: range)
        
        var r : Float = 0.0, g : Float = 0.0, b : Float = 0.0
        Scanner(string: rhex).scanFloat(&r)
        Scanner(string: ghex).scanFloat(&g)
        Scanner(string: bhex).scanFloat(&b)
    
        self.init(r:CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    
    class func randomColor() -> UIColor {
        
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    func getCgcolor() -> (CGFloat, CGFloat, CGFloat) {
    
        guard let rgb = cgColor.components else {
            fatalError("UIColor 不是RGB值");
        }
        return (rgb[0]*255.0, rgb[1]*255.0, rgb[2]*255.0)
    }
    
     class func getRGBDelta(firstColor: UIColor, secondColor : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.getCgcolor()
        let secondRGB = secondColor.getCgcolor()
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
        
    }
    
}
