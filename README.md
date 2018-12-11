# NStack 🛠
[![Swift Version](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-30B6FC.svg)](http://vapor.codes)
[![CircleCI](https://circleci.com/gh/nodes-vapor/nstack/tree/master.svg?style=svg)](https://circleci.com/gh/nodes-vapor/nstack/tree/master)
[![codebeat badge](https://codebeat.co/badges/f324d1a5-28e1-433e-b71c-a2d2d33bb3ec)](https://codebeat.co/projects/github-com-nodes-vapor-nstack-master)
[![codecov](https://codecov.io/gh/nodes-vapor/nstack/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/nstack)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/nstack)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/nstack)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/nstack/master/LICENSE)

This package is a wrapper around the NStack.io API.

Supports the following NStack modules:

- Translate


## 📦 Installation

### Package.swift

Add `NStack` to the Package dependencies:

```swift
dependencies: [
    // ...,
    .package(url: "https://github.com/nodes-vapor/nstack.git", .upToNextMinor(from: "3.0.0"))
]
```

as well as to your target (e.g. "App"):

```swift
targets: [
    .target(name: "App", dependencies: [..., "NStack", ...]),
    // ...
]
```

## Getting started 🚀

Import NStack where needed:
```swift
import NStack
```

### Config

Create `NStack.Config` to configure `NStack`, your `Applications` as well as the default `Translate.Config`.

```swift
let nstackConfig = NStack.Config(
    applicationConfigs: [
        Application.Config.init(
            name: "my app name",
            applicationId: "NEVER_PUT_API_IDS_IN_SOURCE_CODE",
            restKey: "NEVER_PUT_API_KEYS_IN_SOURCE_CODE",
            masterKey: "DEFINITELY_NEVER_EXPOSTE_THE_MASTER_KEY_IN_SOURCE_CODE"
        )
    ],
    defaultTranslateConfig: TranslateController.Config(
        defaultPlatform: .backend,
        defaultLanguage: "en-EN",
        cacheInMinutes: 1
    ),
    log: false
)
```

If you set `log` to `true` you will receive helpful logs in case anything goes wrong.


### Adding the Service

Instantiate and register `NStackProvider` with config created in the previous step.

In `configure.swift`:
```swift
try services.register(NStackProvider(config: nstackConfig))
```

## Usage

```swift
func getProductName(req: Request) throws -> Future<String> {

    // ...

    let nstack = try req.make(NStack.self)
    let translation = nstack.application.translate.get(on: req, section: "products", key: "nstackForSale")

    return translation
}
```

You can also provide `searchReplacePairs`:

```swift
func getProductName(req: Request, owner: String) throws -> Future<String> {

    let nstack = try req.make(NStack.self)
    let translation = nstack.application.translate.get(
        on: req,
        section: "products",
        key: "nstackForSale",
        searchReplacePairs: [
            "productOwner" : owner
        ]
    )

    return translation
}
```

If you are using multiple NStack applications within your project you can switch them with `getApplication()`:

```swift
let nstack = try req.make(NStack.self)
let translation = nstack.getApplication("my app name").translate.get(on: req, section: "products", key: "nstackForSale")
```

Note: you can specify the `get()` call further in case you don't want to go with the values provided in `defaultTranslateConfig`:

```swift
let translation = nstack.application.translate.get(
    on: req,
    platform: .backend,
    language: "dk-DK",
    section: "products",
    key: "nstackForSale",
    searchReplacePairs: [
        "productOwner" : "Christian"
    ]
)
```

### Caching

NStack uses the `KeyedCache` registered with Vapor. If you don't register any Cache, this should be the `KeyedMemory` Cache. If you configure Vapor to prefer another Cache, NStack will use this one instead. Example for Redis:

In `configure.swift`:
```swift
config.prefer(DatabaseKeyedCache<ConfiguredDatabase<RedisDatabase>>.self, for: KeyedCache.self)
```

### Leaf Tag
In order to render the NStack Leaf tags, you will need to add them first:
```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    services.register { container -> LeafTagConfig in
        var tags = LeafTagConfig.default()
        try tags.useNStackLeafTags(container)
        return tags
    }
}
```

NStack comes with a built-in Leaf tag. The tag yields a translated string or the given key if translation fails
```swift
// Get translation for camelCasedSection.camelCasedKey
#nstack:translate("camelCasedSection", "camelCasedKey")

// Get translation for camelCasedSection.camelCasedKey and replace searchString1 with replaceString1 etc
#nstack:translate("camelCasedSection", "camelCasedKey", "searchString1", "replaceString1", "searchString2", "replaceString2", ...)
```

Please note that the leaf tag always uses the **current application** with the **default translate config** that you have provided.

## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [Christian](https://github.com/cweinberger).

## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
