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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func menuButtonTapped(sender: AnyObject) {
        
        // close GuillotineMenuViewController whis is the parent view controller now
        let guillotineViewController = self.parentViewController! as! GuillotineMenuViewController
        guillotineViewController.closeMenu(true)
    }
}