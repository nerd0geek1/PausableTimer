# PausableTimer
[![Build Status](https://travis-ci.org/nerd0geek1/Logger.svg?branch=master)](https://travis-ci.org/nerd0geek1/PausableTimer)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This is Timer module written in Swift

## How to use
PausableTimer provides two classes.

### PausableTimer
PausableTimer provide stopwatch function.
```Swift
PausableTimer.sharedInstance.setDuration(200)

PausableTimer.sharedInstance.didStart = {
    print("This text will be printed when timer was started.")
}
PausableTimer.sharedInstance.didPause = {
    print("This text will be printed when timer was paused.")
}
PausableTimer.sharedInstance.didResume = {
  print("This text will be printed when timer was resumed.")
}
PausableTimer.sharedInstance.didStop = {isFinished in
  print("This text will be printed when stop() method was called or elapsed duration.")
}

print(PausableTimer.sharedInstance.isRunning())         //false
print(PausableTimer.sharedInstance.remainingDuration()) //200

PausableTimer.sharedInstance.start() //This will invoke didStart closure

print(PausableTimer.sharedInstance.isRunning())         //true

//10sec later...
print(PausableTimer.sharedInstance.remainingDuration()) //190

PausableTimer.sharedInstance.pause() //This will invoke didPause closure

print(PausableTimer.sharedInstance.isRunning())         //false

PausableTimer.sharedInstance.resume() //This will invoke didResume closure

print(PausableTimer.sharedInstance.isRunning())         //true
```

### TimerDurationConverter
TimerDurationConverter generate appropriate string from duration.

```swift
print(TimerDurationConverter.durationString(30))   //00:30
print(TimerDurationConverter.durationString(1800)) //30:00
print(TimerDurationConverter.durationString(3690)) //01:01:30
```
## Requirements
- iOS 9.0+
- Xcode 7.3 or above

PausableTimer is now supporting Swift2.2.

## Installation
PausableTimer supports only iOS and Carthage.

## Installation with Carthage
To integrate PausableTimer into your Xcode project using Carthage, specify it in your Cartfile:
```ogdl
github "nerd0geek1/PausableTimer"
```

Then, run the following command:
```bash
$ carthage update
```

## License
This software is Open Source under the MIT license, see LICENSE for details.
