# NetworkMonitor

## Installation

### Carthage

add to your `Cartfile`
```
github "OlegKetrar/NetworkMonitor" "master"
```

then run
```sh
carthage update --use-xcframeworks
```

and drag & drop `Carthage/Build/EventMonitor.xcframework` to your project. 

Import `EventMonitor` (**Notice the different name**) 

```swift
import EventMonitor
```

## Exclusing from Release builds

### Swift Package Manager

In Xcode, navigate to `Build Settings` > `Build Options` > `Excluded Source File Names`. For your `Release` configuration, set it to `MonitorCore.o MonitoreCore.o Monitor.o`.

<img width="500" alt="excluded_spm" src="https://user-images.githubusercontent.com/14060259/149197809-09dd744a-1f56-4995-b78a-ea0bf25fab94.png">

### Carthage
 
In Xcode, navigate to `Build Settings` > `Build Options` > `Excluded Source File Names`. For your `Release` configuration, set it to `EventMonitor*`.

<img width="500" alt="excluded_carthage" src="https://user-images.githubusercontent.com/14060259/149197797-6c407246-015c-494c-a98a-0c40283f5c60.png">
