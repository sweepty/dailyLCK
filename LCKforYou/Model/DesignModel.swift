//
//  DesignModel.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 04/06/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

//import Foundation
import UIKit

@IBDesignable
class RoundView: UIView {
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        } set {
            self.layer.cornerRadius = self.frame.height/20
        }
    }
}

@IBDesignable
class CircleView: UIView {
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        } set {
            self.layer.cornerRadius = self.frame.width/2
        }
    }
}

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        } set {
            self.layer.cornerRadius = self.frame.height/5
        }
    }
}
