//
//  GuillotineMenuNavigationControllerDelegate.swift
//  GuillotineMenuExample
//
//  Created by Maksym Lazebnyi on 10/7/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit

class GuillotineMenuNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if toVC.conformsToProtocol(GuillotineAnimationProtocol) && operation == UINavigationControllerOperation.Push {
                return GuillotineTransitionAnimation(GuillotineTransitionAnimation.Mode.Presentation)
            } else if fromVC.conformsToProtocol(GuillotineAnimationProtocol) && operation == UINavigationControllerOperation.Pop {
                return GuillotineTransitionAnimation(GuillotineTransitionAnimation.Mode.Dismissal)
            }
            return nil
    }
}