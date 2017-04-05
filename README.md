# NStack
[![Language](https://img.shields.io/badge/Swift-3-brightgreen.svg)](http://swift.org)
[![Build Status](https://travis-ci.org/nodes-vapor/nstack.svg?branch=master)](https://travis-ci.org/nodes-vapor/nstack)
[![codecov](https://codecov.io/gh/nodes-vapor/nstack/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nstack)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nstack/master/LICENSE)


This package is a wrapper around the NStack.io API 

Following features
 - Translate

# Installation

#### Config
Create config `nstack.json`
```
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
