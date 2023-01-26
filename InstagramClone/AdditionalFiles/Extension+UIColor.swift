//
//  Extension+UIColor.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 7.09.2022.
//

import Foundation
import UIKit


extension UIColor {
    static func mainBlue() -> UIColor {
        return UIColor.RGBConverter(red: 20, green: 155, blue: 235)
    }
    static func RGBConverter(red : CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
   
}
