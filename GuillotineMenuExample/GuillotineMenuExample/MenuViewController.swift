//
//  MenuViewController.swift
//  GuillotineMenuExample
//
//  Created by Maksym Lazebnyi on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit



class MenuViewController: UIViewController {
    
    var titleString: String!
    
    typealias MenuClosureBlock = (String) -> Void
    var closureBlock: MenuClosureBlock!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        closureBlock?(sender.accessibilityLabel!)
    }
}