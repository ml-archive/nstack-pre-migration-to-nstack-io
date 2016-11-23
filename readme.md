This package is a wrapper around the NStack.io API 

Following features
 - Translate

#Installation

#### Config
Create config nstack.json

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

### main.swift
```
import NStack
```

And add provider
```
try drop.addProvider(NStackProvider(drop: drop))
```

Consider making a easy accessible var
```
let translate = drop.nstack?.application.translate.self
```

###Usages
```
// With shortcut
translate?.get(section: "default", key: "ok")

// Through drop
drop.nstack?.application.translate.get(platform: "backend", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"])
```