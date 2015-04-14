
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
```ruby
pod 'GuillotineMenu', '~> 1.0.0'
```

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

Copyright 2015, Yalantis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
