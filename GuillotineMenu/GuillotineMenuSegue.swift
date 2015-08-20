//
//  GuillotineMenuSegue.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private var key = 0

class GuillotineMenuSegue: UIStoryboardSegue {
    override init!(identifier: String!, source: UIViewController, destination: UIViewController) {

        if let animationDelegate = destination as? protocol<GuillotineAnimationDelegate> {
            // do nothing
        }else{
            assert(true, "Destination must conform to \(NSStringFromProtocol(GuillotineAnimationProtocol)) protocol")
        }
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let source = sourceViewController as! UIViewController
        let target = destinationViewController as! UIViewController
        target.transitioningDelegate = self
        target.modalPresentationStyle = .Custom
        source.presentViewController(target, animated: true, completion: nil)
    }
}

extension GuillotineMenuSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController _: UIViewController,
        sourceController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            objc_setAssociatedObject(presented, &key, self, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            return GuillotineTransitionAnimation(.Presentation)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GuillotineTransitionAnimation(.Dismissal)
    }
}