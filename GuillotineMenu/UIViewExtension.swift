//
//  FillWithView.swift
//  Memo
//
//  Created by Maksym Lazebnyi on 1/30/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func addScaleToFitView (view: UIView?, insets:UIEdgeInsets) {
        if let fillView = view {
            fillView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addConstraint(NSLayoutConstraint(item: fillView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: insets.top))
            self.addConstraint(NSLayoutConstraint(item: fillView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: insets.left))
            self.addConstraint(NSLayoutConstraint(item: fillView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: insets.right))
            self.addConstraint(NSLayoutConstraint(item: fillView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: insets.right))
        }
    }
    
    func addConstraintsForMenuButton (button: UIButton?, offset:UIOffset) -> (NSLayoutConstraint, NSLayoutConstraint) {
        var leading: NSLayoutConstraint!
        var top: NSLayoutConstraint!
        if let fillView = button {
            self.removeConstraints(fillView.constraints())
            fillView.setTranslatesAutoresizingMaskIntoConstraints(false)
            top = NSLayoutConstraint(item: fillView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: offset.vertical)
            self.addConstraint(top)
            leading = NSLayoutConstraint(item: fillView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: offset.horizontal)
            self.addConstraint(leading)
            fillView.addConstraint(NSLayoutConstraint(item: fillView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30.0))
            fillView.addConstraint(NSLayoutConstraint(item: fillView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30.0))
            return (leading, top)
        }
        return (leading, top)
    }
}
