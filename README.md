
# GuillotineMenu.swift
![Preview](https://d13yacurqjgara.cloudfront.net/users/495792/screenshots/2018249/draft_06.gif)

Guillotine Menu

Made in [Yalantis](http://yalantis.com/).

Inspired by [this project on Dribbble](https://dribbble.com/shots/2018249-Side-Topbar-Animation)

Also, read how it was done in our [blog](http://yalantis.com/blog/how-we-created-guillotine-menu-animation/)

## Requirements
iOS 8.0

## Installation

####[CocoaPods](http://cocoapods.org)
Coming soon.

####Manual Installation

You are welcome to see the sample of the project for fully operating sample in the Example folder.

* Add the folder "GuillotineMenu" to your project.
* Create a view controller in the interface builder and set it's class to be GuillotineMenuViewController or it's subclass.
* Set the connetion from your view controller to the GuillotineMenuViewController with GuillotineMenuSegue
* Call destinationVC.setMenuButtonWithImage(<#UIImage>) in prepareForSegue method if it is GuillotineMenuSegue

```swift
@objc protocol GuillotineAnimationProtocol: NSObjectProtocol {
   func navigationBarHeight() -> CGFloat
   func anchorPoint() -> CGPoint
   func hostTitle () -> NSString
}
```

* You need to set the properties for the GuillotineMenuViewController as shown in the sample below: 

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   let destinationVC = segue.destinationViewController as! GuillotineMenuViewController
   destinationVC.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
   destinationVC.hostTitleText = self.navigationItem.title
   destinationVC.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
   destinationVC.setMenuButtonWithImage(barButton.imageView!.image!)
}
```

* The image rotation will be done for you, just pass the image for the menu button.

### Customisation

You are welcome to set any background color for the GuillotineMenuViewController's view but it is recommended to use the same color you use for the navigation bar.
Also the menu bar button is recommended to be set the way it is set in the sample project.

The menu look customization is limited with your imagination only. Feel free to give it any look you want in the interface builder or programmatically.

### Compatibility

iOS 8

#### Version: 1.0

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
