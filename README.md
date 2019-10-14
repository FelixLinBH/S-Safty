# S-safty

> Made common component thread-safty.

[![CI Status](https://img.shields.io/travis/FelixLinBH/S-Safty.svg?style=flat)](https://travis-ci.org/FelixLinBH/s-safty)
[![Version](https://img.shields.io/cocoapods/v/S-Safty.svg?style=flat)](https://cocoapods.org/pods/s-safty)
[![License](https://img.shields.io/cocoapods/l/S-Safty.svg?style=flat)](https://cocoapods.org/pods/s-safty)
[![Platform](https://img.shields.io/cocoapods/p/S-Safty.svg?style=flat)](https://cocoapods.org/pods/s-safty)

## Requirements

- Swift 4.0+

## Installation

s-safty is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 's-safty'
```
## Usage

### Create thread-safty class with any type 

```
let array = SyncArray<Any>( )
let dictionnary = SyncDictionary<String, Any>()
let data = SyncData()
```

**The thread-safty class of usage is the same as the structure**

### Support of the structure

* Array
* Dictionary
* Data

## Author

FelixLinBH, linhandev@gmail.com

## License

comthreadsafety is available under the MIT license. See the LICENSE file for more info.
