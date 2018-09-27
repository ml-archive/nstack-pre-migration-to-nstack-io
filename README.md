# NStack
[![Swift Version](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/nstack/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/nstack)
[![codebeat badge](https://codebeat.co/badges/f324d1a5-28e1-433e-b71c-a2d2d33bb3ec)](https://codebeat.co/projects/github-com-nodes-vapor-nstack-master)
[![codecov](https://codecov.io/gh/nodes-vapor/nstack/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nstack)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/nstack)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/nstack)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nstack/master/LICENSE)


This package is a wrapper around the NStack.io API.

Supports the following features:
 - Translate


## 📦 Installation

Update your `Package.swift` file.

```swift
.Package(url: "https://github.com/nodes-vapor/nstack.git", majorVersion: 2)
```

### Config
Create config `nstack.json`
```json
{
    "log": false,
    "defaultApplication": "appOne",
    "translate": {
        "defaultPlatform": "backend",
        "defaultLanguage": "en-UK",
        "cacheInMinutes": 60
    },
    "applications": [
        {
            "name": "appOne",
            "applicationId": "secret",
            "restKey": "secret",
            "masterKey": "secret"
        }
    ]
}
```
Make sure that client is set to foundation in `droplet.json` because the engine client does not properly support the required SSL connections.
```json
  ...
  "client": "foundation",
  ...
```

## Getting started 🚀

### `Config+Setup.swift`
```swift
import NStack
```

And add provider
```swift
try addProvider(NStackProvider.self)
```

### `Droplet+Setup.swift`
```swift
import NStack
```

And register the nstack leaf tag
```swift
extension Droplet {
    // ...
    guard let leaf = view as? LeafRenderer else {
        fatalError("Leaf not configured.")
    }

    leaf.stem.register(NStackTag(nStack: self.nstack))
    // ...
}
```

### Usages

Consider making a easy accessible var
```swift
let translate = drop.nstack?.application.translate
```

```swift
// With default language and platform
translate?.get(section: "default", key: "ok")

// Specifying language and platform and replacing placeholders
translate?.get(platform: "backend", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"])
```

Leaf usage yields a translated string or the given key if translationfails
```swift
#nstack("camelCasedSection", "camelCasedKey")
```

## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [Rasmus](https://github.com/rasmusebbesen).

## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
