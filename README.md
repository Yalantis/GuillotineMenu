# GuillotineMenu.swift 

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GuillotineMenu.svg)](https://img.shields.io/cocoapods/v/GuillotineMenu.svg)

![Preview](https://d13yacurqjgara.cloudfront.net/users/495792/screenshots/2018249/draft_06.gif)

Inspired by [this project on Dribbble](https://dribbble.com/shots/2018249-Side-Topbar-Animation)

Also, read how it was done in our [blog](https://yalantis.com/blog/how-we-created-guillotine-menu-animation/)


## Requirements

- iOS 8.0+
- Xcode 8
- Swift 3

## Installation

#### [CocoaPods](http://cocoapods.org)

```ruby
pod 'GuillotineMenu', '~> 3.0'
```

#### Manual Installation

You are welcome to see the sample of the project for fully operating sample in the Example folder.

* You must add "GuillotineMenuTransitionAnimation.swift" to your project, that's all.

### Usage

* Now, it's for you to decide, should or not your menu drop from top left corner of the screen or from your navigation bar, because if you want animation like in example, you must make your menu view controller confirm to "GuillotineMenu" protocol. When you confirm to this protocol, you must make a menu button and title, you don't need to make frame for them, because animator will make it itself.
* In view controller, that will present your menu, you must make a property for "GuillotineMenuTransitionAnimator". It's necessary for proper animation when you show or dismiss menu.
* When you present menu, you must ensure, that model presentation style set to Custom and menu's transition delegate set to view controller, that presents menu:

```swift
let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
menuViewController.modalPresentationStyle = .custom
menuViewController.transitioningDelegate = self
```

* Implement UIViewControllerTransitionDelegate methods in your presenting view controller:

```swift
extension ViewController: UIViewControllerTransitioningDelegate {

func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
	presentationAnimator.mode = .presentation
	return presentationAnimator
}

func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
	presentationAnimator.mode = .dismissal
	return presentationAnimator
}
```

* At last, you can assign offset view, from where your menu will be dropped and button for it, and present your menu: 

```swift
presentationAnimator.supportView = navigationController!.navigationBar
presentationAnimator.presentButton = sender
present(menuViewController, animated: true, completion: nil)
```

### Customisation

Of course, you can assign different "supportView" or "presentButton" for menu, but we think that's the best case would be behaviour like in Example project.

To specify the length of an animation effect, change the value of the "duration" property.

Also, you have wonderful delegate methods of animator:

```swift
public protocol GuillotineAnimationDelegate: class {
	
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation)
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation)
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation)
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation)
}
```
You can do whatever you want alongside menu is animating.

### Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation. 

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!


### License

	The MIT License (MIT)

	Copyright © 2017 Yalantis

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
