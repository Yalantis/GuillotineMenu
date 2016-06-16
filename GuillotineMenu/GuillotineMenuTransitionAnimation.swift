//
//  GuillotineTransitionAnimation.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

@objc
protocol GuillotineMenu: NSObjectProtocol {
	
    optional var dismissButton: UIButton! { get }
    optional var titleLabel: UILabel! { get }
}

@objc
protocol GuillotineAnimationDelegate: NSObjectProtocol {
	
    optional func animatorDidFinishPresentation(animator: GuillotineTransitionAnimation)
    optional func animatorDidFinishDismissal(animator: GuillotineTransitionAnimation)
    optional func animatorWillStartPresentation(animator: GuillotineTransitionAnimation)
    optional func animatorWillStartDismissal(animator: GuillotineTransitionAnimation)
}

class GuillotineTransitionAnimation: NSObject {
	
    enum Mode { case Presentation, Dismissal }
    
    //MARK: - Public properties
    weak var animationDelegate: GuillotineAnimationDelegate?
    var mode: Mode = .Presentation
    var supportView: UIView?
    var presentButton: UIView?
    var duration = 0.6
    
    //MARK: - Private properties
    private var chromeView: UIView?
    private var containerMenuButton: UIButton? {
        didSet {
            presentButton?.addObserver(self, forKeyPath: "frame", options: .New, context: myContext)
        }
    }
    private var displayLink: CADisplayLink!
    private var vectorDY: CGFloat = 1500
    private var fromYPresentationLandscapeAdjustment: CGFloat = 1.0
    private var fromYDismissalLandscapeAdjustment: CGFloat = 1.0
    private var toYDismissalLandscapeAdjustment: CGFloat = 1.0
    private var fromYPresentationAdjustment: CGFloat = 1.0
    private var fromYDismissalAdjustment: CGFloat = 1.0
    private var toXPresentationLandscapeAdjustment: CGFloat = 1.0
    private let initialMenuRotationAngle: CGFloat = -90
    private let menuElasticity: CGFloat = 0.6
    private let vectorDYCoefficient: Double = 2 / M_PI
    private var topOffset: CGFloat = 0
    private var anchorPoint: CGPoint!
    private var menu: UIViewController!
    private var animationContext: UIViewControllerContextTransitioning!
    private var animator: UIDynamicAnimator!
    private let myContext: UnsafeMutablePointer<()> = nil
    
    //MARK: - Deinitialization
    deinit {
        displayLink.invalidate()
        presentButton?.removeObserver(self, forKeyPath: "frame")
    }
    
    //MARK: - Initialization
    override init() {
        super.init()
        setupDisplayLink()
        setupSystemVersionAdjustment()
    }
    
    //MARK: - Private methods
    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        menu = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
        context.containerView()!.addSubview(menu.view)
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            updateChromeView()
            menu.view.addSubview(chromeView!)
        }
        
        if menu is GuillotineMenu {
            if supportView != nil  && presentButton != nil {
                let guillotineMenu = menu as! GuillotineMenu
                containerMenuButton = guillotineMenu.dismissButton
                setupContainerMenuButtonFrameAndTopOffset()
                context.containerView()!.addSubview(containerMenuButton!)
            }
        }
        
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
        fromVC?.beginAppearanceTransition(false, animated: true)
        
        animationDelegate?.animatorWillStartPresentation?(self)
        
        animateMenu(menu.view, context: context)
    }
    
    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        menu = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        if menu.navigationController != nil {
            let toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)!
            context.containerView()!.addSubview(toVC.view)
            context.containerView()!.sendSubviewToBack(toVC.view)
        }
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            updateChromeView()
            menu.view.addSubview(chromeView!)
        }
        
        let toVC = context.viewControllerForKey(UITransitionContextToViewControllerKey)
        toVC?.beginAppearanceTransition(true, animated: true)

        animationDelegate?.animatorWillStartDismissal?(self)
        
        animateMenu(menu.view, context: context)
    }
    
    private func animateMenu(view: UIView, context:UIViewControllerContextTransitioning) {
        animationContext = context
        animator = UIDynamicAnimator(referenceView: context.containerView()!)
        animator.delegate = self
        vectorDY = CGFloat(vectorDYCoefficient * Double(UIScreen.mainScreen().bounds.size.height) / duration)
        
        var rotationDirection = CGVectorMake(0, -vectorDY)
        var fromX: CGFloat
        var fromY: CGFloat
        var toX: CGFloat
        var toY: CGFloat
        if self.mode == .Presentation {
            if supportView != nil {
                showHostTitleLabel(false, animated: true)
            }
            view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(initialMenuRotationAngle));
            view.frame = CGRectMake(0, -CGRectGetHeight(view.frame)+topOffset, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))
            rotationDirection = CGVectorMake(0, vectorDY)
            
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {

                fromX = CGRectGetWidth(context.containerView()!.frame) - 1
                fromY = CGRectGetHeight(context.containerView()!.frame) + fromYPresentationLandscapeAdjustment
                toX = fromX + toXPresentationLandscapeAdjustment
                toY = fromY
            } else {
                fromX = -1
                fromY = CGRectGetHeight(context.containerView()!.frame) + fromYPresentationAdjustment
                toX = fromX
                toY = fromY + 1
            }
        } else {
            if supportView != nil {
                showHostTitleLabel(true, animated: true)
            }
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                fromX = -1
                fromY = -CGRectGetWidth(context.containerView()!.frame) + topOffset + fromYDismissalLandscapeAdjustment
                toX = fromX
                toY = fromY + toYDismissalLandscapeAdjustment
            } else {
                fromX = CGRectGetHeight(context.containerView()!.frame) - 1
                fromY = -CGRectGetWidth(context.containerView()!.frame) + topOffset + fromYDismissalAdjustment
                toX = fromX + 1
                toY = fromY
            }
        }
        
        let anchorPoint = CGPointMake(topOffset / 2, topOffset / 2)
        let viewOffset = UIOffsetMake(-view.bounds.size.width / 2 + anchorPoint.x, -view.bounds.size.height / 2 + anchorPoint.y)
        let attachmentBehaviour = UIAttachmentBehavior(item: view, offsetFromCenter: viewOffset, attachedToAnchor: anchorPoint)
        animator.addBehavior(attachmentBehaviour)

        let collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.addBoundaryWithIdentifier("collide", fromPoint: CGPointMake(fromX, fromY), toPoint: CGPointMake(toX, toY))
        collisionBehaviour.addItem(view)
        animator.addBehavior(collisionBehaviour)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [view])
        itemBehaviour.elasticity = menuElasticity
        animator.addBehavior(itemBehaviour)
        
        let fallBehaviour = UIPushBehavior(items:[view], mode: .Continuous)
        fallBehaviour.pushDirection = rotationDirection
        animator.addBehavior(fallBehaviour)
        //Start displayLink
        displayLink.paused = false
    }
    
    private func showHostTitleLabel(show: Bool, animated: Bool) {
        if let guillotineMenu = menu as? GuillotineMenu {
            guard guillotineMenu.titleLabel != nil else { return }
            guillotineMenu.titleLabel!.center = CGPointMake(CGRectGetHeight(supportView!.frame) / 2, CGRectGetWidth(supportView!.frame) / 2)
            guillotineMenu.titleLabel!.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
            menu.view.addSubview(guillotineMenu.titleLabel!)
            if mode == .Presentation {
                guillotineMenu.titleLabel!.alpha = 1;
            } else {
                guillotineMenu.titleLabel!.alpha = 0;
            }
            
            if animated {
                UIView.animateWithDuration(duration, animations: {
                    guillotineMenu.titleLabel!.alpha = CGFloat(show)
                    }, completion: nil)
            } else {
                guillotineMenu.titleLabel!.alpha = CGFloat(show)
            }
        }
    }
    
    private func updateChromeView() {
        chromeView = UIView(frame: CGRectMake(0, CGRectGetHeight(menu.view.frame), CGRectGetWidth(menu.view.frame), CGRectGetHeight(menu.view.frame)))
        chromeView!.backgroundColor = menu.view.backgroundColor
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateContainerMenuButton))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = true
    }
    
    private func setupSystemVersionAdjustment() {
        let device = UIDevice.currentDevice()
        let iosVersion = Double(device.systemVersion) ?? 0
        let iOS9 = iosVersion >= 9
        
        if (iOS9) {
            fromYPresentationLandscapeAdjustment = 1.5
            fromYDismissalLandscapeAdjustment = 1.0
            fromYPresentationAdjustment = -1.0
            fromYDismissalAdjustment = -1.0
            toXPresentationLandscapeAdjustment = 1.0
            toYDismissalLandscapeAdjustment = -1.0
        } else {
            fromYPresentationLandscapeAdjustment = 0.5
            fromYDismissalLandscapeAdjustment = 0.0
            fromYPresentationAdjustment = -1.5
            fromYDismissalAdjustment = 1.0
            toXPresentationLandscapeAdjustment = -1.0
            toYDismissalLandscapeAdjustment = 1.5
        }
    }
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees / 180.0 * CGFloat(M_PI)
    }
	
    private func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return radians * 180.0 / CGFloat(M_PI)
    }
	
    @objc
		private func updateContainerMenuButton() {
        let rotationTransform: CATransform3D = menu.view.layer.presentationLayer()!.transform
        var angle: CGFloat = 0
        if (rotationTransform.m11 < 0.0) {
            angle = 180.0 - radiansToDegrees(asin(rotationTransform.m12))
        } else {
            angle = radiansToDegrees(asin(rotationTransform.m12))
        }
        let degrees: CGFloat = 90 - abs(angle)
        containerMenuButton?.layer.transform = CATransform3DRotate(CATransform3DIdentity, degreesToRadians(degrees), 0, 0, 1)
    }
    
    func setupContainerMenuButtonFrameAndTopOffset() {
        topOffset = supportView!.frame.origin.y + CGRectGetHeight(supportView!.bounds)
        let senderRect = supportView!.convertRect(presentButton!.frame, toView: nil)
        containerMenuButton?.frame = senderRect
    }
    
    //MARK: - Observer
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == myContext {
            setupContainerMenuButtonFrameAndTopOffset()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

//MARK: - UIViewControllerAnimatedTransitioning protocol implementation
extension GuillotineTransitionAnimation: UIViewControllerAnimatedTransitioning {
	
    func animateTransition(context: UIViewControllerContextTransitioning) {
        switch mode {
        case .Presentation:
            animatePresentation(context)
        case .Dismissal:
            animateDismissal(context)
        }
    }
    
    func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

//MARK: - UIDynamicAnimatorDelegate protocol implementation
extension GuillotineTransitionAnimation: UIDynamicAnimatorDelegate {
	
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        if self.mode == .Presentation {
            self.animator.removeAllBehaviors()
            menu.view.transform = CGAffineTransformIdentity
            menu.view.frame = animationContext.containerView()!.bounds
            anchorPoint = CGPointZero
        }

        chromeView?.removeFromSuperview()
        animationContext.completeTransition(true)
        
        if self.mode == .Presentation {
            let fromVC = animationContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            fromVC?.endAppearanceTransition()
            animationDelegate?.animatorDidFinishPresentation?(self)
        } else {
            let toVC = animationContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            toVC?.endAppearanceTransition()
            animationDelegate?.animatorDidFinishDismissal?(self)
        }
        //Stop displayLink
        displayLink.paused = true
    }
}