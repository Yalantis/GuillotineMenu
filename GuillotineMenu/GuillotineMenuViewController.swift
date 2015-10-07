//
//  GuillotineViewController.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

protocol GuillotineMenuViewControllerDelegate: class {
    func menuOptionTapped(menuOption: String)
}

class GuillotineMenuViewController: UIViewController {

    var hostNavigationBarHeight: CGFloat!
    var hostTitleText: NSString!

    var menuButton: UIButton!
    var menuButtonLeadingConstraint: NSLayoutConstraint!
    var menuButtonTopConstraint: NSLayoutConstraint!
    weak var delegate: GuillotineMenuViewControllerDelegate?
    
    private let menuButtonLandscapeLeadingConstant: CGFloat = 1
    private let menuButtonPortraitLeadingConstant: CGFloat = 7
    private let hostNavigationBarHeightLandscape: CGFloat = 32
    private let hostNavigationBarHeightPortrait: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
// MARK: Actions
    func closeMenuButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setMenuButtonWithImage(image: UIImage) {
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight {
            menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        } else {
            menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        }
        
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.imageView!.contentMode = .Center
        menuButton.addTarget(self, action: Selector("closeMenuButtonTapped"), forControlEvents: .TouchUpInside)
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
    
// MARK: IBAction

    @IBAction func profileButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        //delegate?.menuOptionTapped(sender.accessibilityLabel!)
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
