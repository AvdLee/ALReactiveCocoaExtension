# ALReactiveCocoaExtension

[![Version](https://img.shields.io/cocoapods/v/ALReactiveCocoaExtension.svg?style=flat)](http://cocoapods.org/pods/ALReactiveCocoaExtension)
[![License](https://img.shields.io/cocoapods/l/ALReactiveCocoaExtension.svg?style=flat)](http://cocoapods.org/pods/ALReactiveCocoaExtension)
[![Platform](https://img.shields.io/cocoapods/p/ALReactiveCocoaExtension.svg?style=flat)](http://cocoapods.org/pods/ALReactiveCocoaExtension)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The pod includes extensions for `RACSignal` and adds replacements for the `RAC` and `RACObserve` macros we're used to in Objective-C.

### SignalProducer extension
This pod includes an extension for the new `SignalProducer`. This brings the methods we're familiar with from earlier versions of ReactiveCocoa.

```swift
let producer = SignalProducer<String, NSError>(value: "testValue")
    
// Prints "producer started!"
producer.onStarted { () -> () in
    print("producer started!")
}.start()
    
// Prints "testValue"
producer.onNext { (object) -> () in
    print(object)
}.start()
    
// Prints "testValue", can be used to cast AnyObjects for example
producer.onNextAs { (string:String) -> () in
    print(string)
}.start()
    
// Prints "testValue", can be used to cast AnyObjects for example
producer.startWithNextAs { (string:String) -> () in
    print(string)
}
    
// Prints "Error Domain=sample.domain Code=-1 "(null)""
let errorProducer = SignalProducer<String, NSError>(error:NSError(domain: "sample.domain", code: -1, userInfo: nil))
errorProducer.onError { (error) -> () in
    print(error)
}.start()
```

## Requirements
- This pod requires `ReactiveCocoa 4.2.0 and up`
- Swift 3.0
- iOS 8+
- tvOS 9+
- watchOS 2+

## Installation

ALReactiveCocoaExtension is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ALReactiveCocoaExtension"
```

#### Swift version vs Pod version
| Swift version | Pod version    |
| ------------- | --------------- |
| 3.X           | >= 4.0.0			|
| 2.3           | 3.0.3			   |

## Author

Antoine van der Lee, 
https://twitter.com/twannl
https://www.avanderlee.com

## License

ALReactiveCocoaExtension is available under the MIT license. See the LICENSE file for more info.
