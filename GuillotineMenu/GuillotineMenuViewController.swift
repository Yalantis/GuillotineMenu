//
//  GuillotineViewController.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

class GuillotineMenuViewController: UIViewController {
    
    var contentViewController: UIViewController?

    var hostNavigationBarHeight: CGFloat!
    var hostTitleText: NSString!

    var menuButton: UIButton!
    var menuButtonLeadingConstraint: NSLayoutConstraint!
    var menuButtonTopConstraint: NSLayoutConstraint!
    
    private let menuButtonLandscapeLeadingConstant: CGFloat = 1
    private let menuButtonPortraitLeadingConstant: CGFloat = 7
    private let hostNavigationBarHeightLandscape: CGFloat = 32
    private let hostNavigationBarHeightPortrait: CGFloat = 44
    
    override func viewDidLoad() {
        setMenuButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        view.addAspectToFitView(contentViewController?.view, insets: UIEdgeInsetsZero)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in
            if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
                self.menuButtonLeadingConstraint.constant = self.menuButtonLandscapeLeadingConstant
                self.menuButtonTopConstraint.constant = self.menuButtonPortraitLeadingConstant
            } else {
                let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                self.menuButtonLeadingConstraint.constant = self.menuButtonPortraitLeadingConstant;
                self.menuButtonTopConstraint.constant = self.menuButtonPortraitLeadingConstant+statusbarHeight
            }
        }
    }
    
    func addContentViewController(viewController: UIViewController) {
        contentViewController = viewController;
        viewController.view.frame = view.bounds
        self.view.insertSubview(viewController.view, belowSubview: menuButton)
    }
    
    private func setMenuButton() {
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let image = UIImage(named: "ic_menu")
        menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        
        menuButton.setImage(image, forState: .Normal)
        menuButton.imageView!.contentMode = .Center
        menuButton.addTarget(self, action: Selector("closeMenuAnimated"), forControlEvents: .TouchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.transform = CGAffineTransformMakeRotation( ( 90 * CGFloat(M_PI) ) / 180 );
        self.view.addSubview(menuButton)
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            let (leading, top) = self.view.addConstraintsForMenuButton(menuButton, offset: UIOffsetMake(menuButtonLandscapeLeadingConstant, menuButtonPortraitLeadingConstant))
            menuButtonLeadingConstraint = leading
            menuButtonTopConstraint = top
        } else {
            let (leading, top) = self.view.addConstraintsForMenuButton(menuButton, offset: UIOffsetMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight))
            menuButtonLeadingConstraint = leading
            menuButtonTopConstraint = top
        }
    }
    
    func setMenuButtonImage(image:UIImage, state: UIControlState) {
        menuButton.setImage(image, forState: state)
    }
    
// MARK: Actions
    func closeMenuAnimated() {
        self.closeMenu(true)
    }
    
    func closeMenu(animated: Bool) {
        if animated == false {
            self.navigationController?.setNavigationBarHidden(false, animated: false);
        }
         self.navigationController?.popViewControllerAnimated(animated)
    }
}

extension GuillotineMenuViewController: GuillotineAnimationProtocol {

    func anchorPoint() -> CGPoint {
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            //In this case value is calculated manualy as the method is called before viewDidLayourSubbviews when the menuBarButton.frame is updated.
            return CGPointMake(16, 16)
        }
        return self.menuButton.center
    }
    
    func navigationBarHeight() -> CGFloat {
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            return hostNavigationBarHeightLandscape
        } else {
            return hostNavigationBarHeightPortrait
        }
    }
    
    func hostTitle () -> NSString {
        return hostTitleText
    }
}
