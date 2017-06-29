# NStack
[![Swift Version](https://img.shields.io/badge/Swift-3.1-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)
[![Linux Build Status](https://img.shields.io/circleci/project/github/nodes-vapor/nstack.svg?label=Linux)](https://circleci.com/gh/nodes-vapor/nstack)
[![macOS Build Status](https://img.shields.io/travis/nodes-vapor/nstack.svg?label=macOS)](https://travis-ci.org/nodes-vapor/nstack)
[![codebeat badge](https://codebeat.co/badges/52c2f960-625c-4a63-ae63-52a24d747da1)](https://codebeat.co/projects/github-com-nodes-vapor-nstack)
[![codecov](https://codecov.io/gh/nodes-vapor/nstack/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nstack)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/nstack)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/nstack)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nstack/master/LICENSE)


This package is a wrapper around the NStack.io API.

Supports the following features:
 - Translate


## 📦 Installation

Update your `Package.swift` file.

```swift
.Package(url: "https://github.com/nodes-vapor/nstack.git", majorVersion: 1)
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


## Getting started 🚀

### `main.swift`
```swift
import NStack
```

And add provider
```swift
try drop.addProvider(NStackProvider(drop: drop))
```

Consider making a easy accessible var
```swift
let translate = drop.nstack?.application.translate.self
```

### Usages
```swift
// With shortcut
translate?.get(section: "default", key: "ok")

// Through drop
drop.nstack?.application.translate.get(platform: "backend", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"])
```


## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [Rasmus](https://github.com/rasmusebbesen).


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
