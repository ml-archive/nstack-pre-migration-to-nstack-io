# NStack
[![Swift Version](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-1-F6CBCA.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/nstack/tree/vapor-1.svg?style=shield)](https://circleci.com/gh/nodes-vapor/nstack)
[![codebeat badge](https://codebeat.co/badges/eb178c22-167c-44fd-b337-3a4fc0e74324)](https://codebeat.co/projects/github-com-nodes-vapor-nstack-vapor-1)
[![codecov](https://codecov.io/gh/nodes-vapor/nstack/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nstack)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/nstack)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/nstack)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nstack/master/LICENSE)


This package is a wrapper around the NStack.io API 

Supports the following features:
 - Translate


## 📦 Installation

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


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
