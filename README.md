
# GuillotineMenu.swift
![Preview](https://d13yacurqjgara.cloudfront.net/users/495792/screenshots/2018249/draft_06.gif)

Guillotine Menu

Made in [![Yalantis](https://raw.githubusercontent.com/Yalantis/FoldingTabBar.iOS/master/Example/Example/Resources/Images/badge_orage_shadow.png)](http://yalantis.com/?utm_source=github)

Inspired by [this project on Dribbble](https://dribbble.com/shots/2018249-Side-Topbar-Animation)

Also, read how it was done in our [blog](http://yalantis.com/blog/how-we-created-guillotine-menu-animation/)


## Requirements
iOS 8.0 Swift 2.0

## Installation

####[CocoaPods](http://cocoapods.org)
Coming soon.

####Manual Installation

You are welcome to see the sample of the project for fully operating sample in the Example folder.

* Add the folder "GuillotineMenu" to your project.
* Your view controller should be embedded in UINavigationViewController
* Set our GuillotineMenuNavigationControllerDelegate to be a delegate for your UINavigationViewController
* Create a view controller in the interface builder and set it's class to be GuillotineMenuViewController or it's subclass.
* Set the connetion from your view controller to the GuillotineMenuViewController with UIStoryboardSegue

* You need to set the properties for the GuillotineMenuViewController as shown in the sample below: 

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController.isKindOfClass(GuillotineMenuViewController) {
        let destinationVC = segue.destinationViewController as! GuillotineMenuViewController
        destinationVC.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        destinationVC.hostTitleText = self.navigationItem.title
        destinationVC.view.backgroundColor = self.navigationController!.navigationBar.barTintColor

        // The image rotation will be done for you, just pass the image for the menu button.
        destinationVC.setMenuButtonWithImage(barButton.imageView!.image!)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewControllerWithIdentifier("MyMenuVC")
        destinationVC.addChildViewController(menuVC)
    }
}
```
* You can use your own UIviewController subclass instead of GuillotineMenuViewController as soon as your class conforms the GuillotineAnimationProtocol

```swift
@objc protocol GuillotineAnimationProtocol: NSObjectProtocol {
func navigationBarHeight() -> CGFloat
func anchorPoint() -> CGPoint
func hostTitle () -> NSString
}
```

### Usage

All you need to do is just to push the GuillotineMenuViewController (or your controller which conforms GuillotineAnimationProtocol) and it will appear with "guillotine" animation. To hide menu you can call GuillotineMenuViewController's method closeMenu() or popViewControllerAnimated(true) for UINavigationController

To know when animation is complete just override the viewWillAppear(animated) method in your view controllers. It will get called right after Guillotine animation complete.

### Customisation

You are welcome to use anything in the view controller you pass as a ChildViewController to GuillotineMenuViewController. It's UIView will be shown and animated properly as a subview of GuillotineMenuViewController. It is recommended to use the same color you use for the navigation bar.
Also the menu bar button is recommended to be set the way it is set in the sample project.

### Compatibility

iOS 8

#### Version: 1.1

### License

The MIT License (MIT)

Copyright (c) 2015 Yalantis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
