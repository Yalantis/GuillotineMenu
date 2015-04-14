//
//  GuillotineTransitionAnimation.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

@objc protocol GuillotineAnimationProtocol: NSObjectProtocol {
    func navigationBarHeight() -> CGFloat
    func anchorPoint() -> CGPoint
    func hostTitle () -> NSString
}

@objc protocol GuillotineAnimationDelegate: NSObjectProtocol {
    // Your menu view controller will be notified about the animation progress if conforms GuillotineAnimationDelegate protocol
    optional func menuDidCollideWithBoundary()
    optional func menuDidFinishPresentation()
    optional func menuDidFinishDismissal()
    
    optional func willStartPresentation()
    optional func willStartDismissal()
}

class GuillotineTransitionAnimation: NSObject {
    enum Mode { case Presentation, Dismissal }
    
    private let mode: Mode
    private let duration = 0.6
    private let vectorDY: CGFloat = 1500
    private let vectorDx: CGFloat = 0.0
    private let initialMenuRotationAngle: CGFloat = -90
    private let menuElasticity: CGFloat = 0.4
    
    private var statusbarHeight: CGFloat!
    private var navigationBarHeight: CGFloat!
    
    private var menu: UIViewController!
    
    private var anchorPoint: CGPoint!
    private var animationContext: UIViewControllerContextTransitioning!
    
    init(_ mode: Mode) {
        self.mode = mode
    }
    
    var itemBehaviour: UIDynamicItemBehavior!
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator()
    lazy var collisionBehaviour = UICollisionBehavior()
    var fallBehaviour: UIPushBehavior!
    var attachmentBehaviour: UIAttachmentBehavior!
    
    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        menu = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
        if let animationDelegate = menu as? protocol<GuillotineAnimationDelegate> {
            animationDelegate.willStartPresentation?()
        }
        // Move view off screen to avoid blink at start
        menu.view.center = CGPointMake(0, CGRectGetHeight(menu.view.frame))
        menu.beginAppearanceTransition(true, animated: true)
        context.containerView().addSubview(menu.view)
        animateMenu(menu.view, context: context)
    }
    
    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        menu = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if let animationDelegate = menu as? protocol<GuillotineAnimationDelegate> {
            animationDelegate.willStartDismissal?()
        }
        
        let host = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        animator.delegate = self
        animateMenu(menu.view, context: context)
    }
    
    private func animateMenu(view: UIView, context:UIViewControllerContextTransitioning) {
        animationContext = context
        animator = UIDynamicAnimator(referenceView: context.containerView())
        animator.delegate = self
        statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        if let menuProt = menu as? protocol<GuillotineAnimationProtocol> {
            navigationBarHeight = menuProt.navigationBarHeight()
            anchorPoint = menuProt.anchorPoint()
        }
        
        var rotationDirection = CGVectorMake(0, -vectorDY)
        attachmentBehaviour = UIAttachmentBehavior(item: view, offsetFromCenter: UIOffsetMake(-view.bounds.size.width/2+anchorPoint.x, -view.bounds.size.height/2+anchorPoint.y), attachedToAnchor: anchorPoint)
        if self.mode == .Presentation {
            showHostTitleLabel(false, animated: true)
            view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (initialMenuRotationAngle / 180.0) * CGFloat(M_PI));
            view.frame = CGRectMake(-statusbarHeight, -CGRectGetHeight(view.frame)+statusbarHeight+navigationBarHeight, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))
            rotationDirection = CGVectorMake(0, vectorDY)
            
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                collisionBehaviour.addBoundaryWithIdentifier("collide", fromPoint: CGPointMake(CGRectGetHeight(context.containerView().frame), CGRectGetHeight(context.containerView().frame)+0.6),
                                                                          toPoint: CGPointMake(CGRectGetHeight(context.containerView().frame), CGRectGetHeight(context.containerView().frame)+0.6))
            } else {
                collisionBehaviour.addBoundaryWithIdentifier("collide", fromPoint: CGPointMake(-0.6, CGRectGetHeight(context.containerView().frame)/2),
                                                                          toPoint: CGPointMake(-0.6, CGRectGetHeight(context.containerView().frame)))
            }
            
        } else {
            showHostTitleLabel(true, animated: true)
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                collisionBehaviour.addBoundaryWithIdentifier("collide", fromPoint: CGPointMake(-0.6, -CGRectGetHeight(context.containerView().frame)/2),
                                                                          toPoint: CGPointMake(-0.6, -CGRectGetHeight(context.containerView().frame)))
            } else {
                collisionBehaviour.addBoundaryWithIdentifier("collide", fromPoint: CGPointMake(CGRectGetHeight(context.containerView().frame)/2, -CGRectGetWidth(context.containerView().frame)+statusbarHeight+navigationBarHeight),
                                                                          toPoint: CGPointMake(CGRectGetHeight(context.containerView().frame), -CGRectGetWidth(context.containerView().frame)+statusbarHeight+navigationBarHeight))
            }
        }
        animator.addBehavior(self.attachmentBehaviour)
        
        collisionBehaviour.addItem(view)
        collisionBehaviour.collisionDelegate = self
        animator.addBehavior(collisionBehaviour)
        
        itemBehaviour = UIDynamicItemBehavior(items: [view])
        itemBehaviour.elasticity = menuElasticity
        itemBehaviour.resistance = 1
        animator.addBehavior(self.itemBehaviour)
        itemBehaviour.addItem(view)
        
        fallBehaviour = UIPushBehavior(items:[view], mode: .Continuous)
        fallBehaviour.pushDirection = rotationDirection
        animator.addBehavior(self.fallBehaviour)
        fallBehaviour.addItem(view)
    }
    
    private func showHostTitleLabel(show: Bool, animated: Bool) {
        let hostTitleLabel = UILabel()
        menu.view.addSubview(hostTitleLabel)
        hostTitleLabel.numberOfLines = 1;
        
        if let menuProt = menu as? protocol<GuillotineAnimationProtocol> {
            hostTitleLabel.text = menuProt.hostTitle() as String
        }
        
        hostTitleLabel.font = UIFont.boldSystemFontOfSize(17)
        hostTitleLabel.textColor = UIColor.whiteColor()
        hostTitleLabel.sizeToFit()
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        hostTitleLabel.center = CGPointMake(navigationBarHeight / 2, CGRectGetWidth(menu.view.frame) / 2 + statusBarHeight)
        hostTitleLabel.transform = CGAffineTransformMakeRotation( ( 90 * CGFloat(M_PI) ) / 180 );
        if mode == .Presentation {
            hostTitleLabel.alpha = 1;
        } else {
            hostTitleLabel.alpha = 0;
        }
        
        if animated {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                hostTitleLabel.alpha = CGFloat(show)
                }, completion: nil)
        } else {
            hostTitleLabel.alpha = CGFloat(show)
        }
    }
}

extension GuillotineTransitionAnimation: UIViewControllerAnimatedTransitioning {
    func animateTransition(context: UIViewControllerContextTransitioning) {
        switch mode {
        case .Presentation:
            animatePresentation(context)
        case .Dismissal:
            animateDismissal(context)
        }
    }
    
    func transitionDuration(context: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
}

extension GuillotineTransitionAnimation: UICollisionBehaviorDelegate {
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        println("collided")
        if let animationDelegate = menu as? protocol<GuillotineAnimationDelegate> {
                animationDelegate.menuDidCollideWithBoundary?()
        }
    }
}

extension GuillotineTransitionAnimation: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        if self.mode == .Presentation {
            self.animator.removeAllBehaviors()
            menu.view.transform = CGAffineTransformIdentity
            menu.view.frame = animationContext.containerView().bounds
            menu.view.superview!.addScaleToFitView(menu.view, insets: UIEdgeInsetsZero)
            anchorPoint = CGPointZero
            menu.endAppearanceTransition()
            println("finished")
            if let animationDelegate = menu as? protocol<GuillotineAnimationDelegate> {
                animationDelegate.menuDidFinishPresentation?()
            }
        } else {
            menu.view.removeFromSuperview()
            if let animationDelegate = menu as? protocol<GuillotineAnimationDelegate> {
                animationDelegate.menuDidFinishDismissal?()
            }
        }
        animationContext.completeTransition(true)
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        println("started")
    }
}
