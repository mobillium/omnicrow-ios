# Omnicrow iOS SDK


![](https://img.shields.io/badge/platform-ios-green.svg)
![](https://img.shields.io/badge/swift-3.2%2B-brightgreen.svg?style=flat)
![](https://img.shields.io/badge/Xcode-8.0+-red.svg)


To use **Omnicrow iOS SDK**, you have to communicate with us through [Mobillium](http://www.mobillium.com)


## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.2+

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

### Swift 3

To integrate Omnicrow into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Omnicrow', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```
### App Id

You need to get app id for your application [Mobillium](http://www.mobillium.com)

## Usage

### Configuration


* **OmnicrowAppID** Will be provided by [Mobillium](http://www.mobillium.com)
* **OmnicrowSandbox** true if you want to test in sandbox environment


In Xcode, secondary-click your project's .plist file and select Open As -> Source Code.

Insert the following XML snippet into the body of your file just before the final </dict> element.

If you already have same keys you need to merge them

```xml
<dict>
	...
	<key>OmnicrowAppID</key>
	<string>exm123456</string>
	<key>OmnicrowSandbox</key>
	<true/>
```

### Initialize

```swift
AppDelegate.swift

import Omnicrow

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        OmnicrowAnalytics.shared.active()

        return true
    }

```

## Events
### Product Views

```swift
import Omnicrow

	OmnicrowAnalytics.logEvent(.item(id: "product_id))
	
```

### Category Views

```swift
import Omnicrow

	var contentId = contentId = "Category > \(category.name) > \(sub_category.name) > \("...")"
	OmnicrowAnalytics.logEvent(.category(path: contentId))

```

### Add to Cart Events

```swift
import Omnicrow

	OmnicrowAnalytics.logEvent(.cart(items: [Omnicrow.Product(id: "product_id, quantity: "product_quantity", price: "product_price)]))

```

### Purchase Events

```swift
import Omnicrow

	OmnicrowAnalytics.logEvent(.purchase(id: "order
_id", totalPrice: "order_total_price", items: [Omnicrow.Product(id: "product_id", quantity: "product_quantity", price: "product_price")]))

```

### Beacon

You must give location permission for detecting beacons.

In Xcode, secondary-click your project's .plist file and select Open As -> Source Code.

Insert the following XML snippet into the body of your file just before the final </dict> element.

```xml
<dict>
	...
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string></string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string></string>
```
These options must be selected.

![Screenshots](https://github.com/mobillium/omnicrow-ios/blob/master/capabilities.png)

## Push
### Push Register

```swift
import Omnicrow

	OmnicrowAnalytics.registerPush("pushToken")

```

## License

Omnicrow is available under the MIT license. See the LICENSE file for more info.
