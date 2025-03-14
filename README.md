# SilverCommunication

`SilverCommunication` is a lightweight Swift library used to perform simple HTTP requests.

- [Requirements](#requirements)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
- [Usage](#usage)
    - [RequestManager](#requestmanager)
        - [Perform request](#perform-request)
        - [Parsing](#parsing)
    - [Request](#request)
    - [Parser](#parser)
        - [ArrayParser](#arrayparser)
        - [DecodableParser](#decodableparser)
        - [DictionaryParser](#dictionaryparser)
        - [Custom Parsers](#custom-parsers)
    - [ResponseValidator](#responsevalidator)
        - [StatusCodeValidator](#statuscodevalidator)
        - [Custom ResponseValidators](#custom-responsevalidators)
    - [Mocking](#mocking)
        - [URLResponse](#urlresponse)
        - [Data](#data)
        - [Encodable](#encodable)
        - [File](#file)
        - [Bundle](#bundle)
        - [Error](#error)


## Requirements

| Platform  | Version   |
| --------  | --------- |
| iOS       | 13.0+     |
| tvOS      | 13.0+     |
| macOS     | 10.15+    |

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/kjeldGr/SilverCommunication.git", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods

### Carthage

## Usage

### RequestManager

To perform HTTP requests with `SilverCommunication` a `RequestManager` instance will be used. The main goal of using this object is making sure all connections to the same server are handled in the same way. Creating an instance of the `RequestManager` is done by passing the base URL of the server that it will communicate with:

```swift
let urlString = URL(string: "https://httpbin.org")!

var requestManager = RequestManager(baseURL: URL(string: urlString)!)

// The base URL can also be passed as String value, however the initializer raises an Error when the String has an invalid URL format
requestManager = try RequestManager(baseURL: urlString)
```

#### Perform request

After creating the `RequestManage`, it can be used to perform HTTP requests using the [Request](#request) model.

```swift
let request = Request(path: "/get")

// Async await
do {
    let response = try await requestManager.perform(request: request)
    debugPrint(response.status) // 200
    debugPrint(response.headers) // `[String: String]` value of the response headers
    debugPrint(response.content) // Optional `Data` value with the content of the response
} catch {
    debugPrint(error)
}

// Completion handler
requestManager.perform(request: request) { result in
    switch result {
    case let .success(response):
        debugPrint(response.status) // 200
        debugPrint(response.headers) // `[String: String]` value of the response headers
        debugPrint(response.content) // Optional `Data` value with the content of the response
    case let .failure(error):
        debugPrint(error)
    }
}
```

#### Parsing

`Parser` types can be used to directly parse the response when the request is finished. Various `Parser` types are by default available within the `SilverCommunication` project, but custom `Parser` types can be created within your own project. For more details on parsing check the [Parser](#parser) documentation.

```swift
struct Item: Decodable {
    let id: String
}

func fetchItem() async throws -> Item {
    return try await requestManager.perform(
        request: Request(path: "/get"), parser: DecodableParser()
    ).content
}
```

### Request

The `Request` model contains all properties related to the specific request to the server. Some examples of how to configure it is shown below:

```swift
// GET request with a path and query parameters (GET is the default HTTP method)
let getRequest = Request(
    path: "/get",
    parameters: ["key": "value"]
)

// POST request with custom headers and a Dictionary (JSON) body
let postRequest = try Request(
    httpMethod: .post,
    path: "/post", 
    headers: [
        .authorization: "Basic <credentials>"
    ],
    // Content-Type application/json header will be added automatically when using this type of body
    body: HTTPBody(jsonObject: ["Key": "Value"])
)

// PUT request with an Encodable (JSON) body
struct BodyItem: Identifiable, Encodable {
    let id: Int
}

let postRequest = try Request(
    httpMethod: .put, 
    path: "/put",
    // Content-Type application/json header will be added automatically when using this type of body
    body: HTTPBody(encodable: BodyItem(id: 1))
)
```

### Parser

`Parser` types can be used to map a `Response` instance with `Data` type content to the expected type. The best use case for the `Parser` is to pass it to a `RequestManager` instance when performing a request. Below you can find some examples about the usage of the default `Parser` implementations:

#### ArrayParser

The `ArrayParser` can be used to parse an `Array` type from a JSON response. The `Element` is a generic type, so it's possible to parse all sorts of `Array` values.

Let's assume the response content looks like this:

```json
{
    "version": 1.0,
    "users": [
        {
            "id": 1,
            "username": "Jules"
        }, {
            "id": 2,
            "username": "Vincent"
        }
    ]
}
```

Parsing this response will be done like:

```swift
// Parsing a (JSON) dictionary from the response (key path is optional)
let response = try await requestManager.perform(
    request: Request(path: "/get"),
    parser: ArrayParser<[String, Any]>(keyPath: "users")
)
debugPrint(response.content) // [["id": 1, "username": "Jules"], ["id": 2, "username": "Vincent"]]
```

#### DecodableParser

The `DecodableParser` can be used to parse a `Decodable` type from a JSON response.

Let's assume the response content looks like this:

```json
{
    "version": 1.0,
    "users": [
        {
            "id": 1,
            "username": "Jules"
        }, {
            "id": 2,
            "username": "Vincent"
        }
    ]
}
```

Parsing this response will be done like:

```swift
struct User: Identifiable, Decodable {
    let id: Int
    let username: String
}

// Parsing a (JSON) dictionary from the response (key path is optional)
let response = try await requestManager.perform(
    request: Request(path: "/get"),
    parser: DecodableParser<[User]>(keyPath: "users")
)
debugPrint(response.content) // [User(id: 1, username: "Jules"), User(id: 2, username: "Vincent")]
```

#### DictionaryParser

The `DictionaryParser` can be used to parse a `Dictionary` from a JSON response. The `Key` and `Value` are generic types, so it's possible to parse all sorts of dictionaries as long as the `Key` type conforms to `Hashable`.

Let's assume the response content looks like this:

```json
{
    "version": 1.0,
    "user": {
        "id": 1,
        "username": "Jules"
    }
}
```

Parsing this response will be done like:

```swift
// Parsing a (JSON) dictionary from the response (key path is optional)
let response = try await requestManager.perform(
    request: Request(path: "/get"),
    parser: DictionaryParser<String, Any>(keyPath: "user")
)
debugPrint(response.content) // ["id": 1, "username": "Jules"]
```

#### Custom Parsers

If you would like to create your own `Parser` type, just create a new type that conforms to the `Parser` protocol. For example a `Parser` that maps the response `Data` to a (UTF-8 encoded) `String` would look like this:

```swift
import Foundation
import SilverCommunication

struct StringParser: Parser {
    func parse(response: Response<Data>) throws -> Response<String> {
        return Response(
            statusCode: response.statusCode,
            headers: response.headers, 
            content: String(decoding: response.content, as: UTF8.self)
            )
    }
}
```

### ResponseValidator

If you want to validate a `Response` before it being returned in the `perform(request:)` method of `RequestManager` you can pass an `Array` of `ResponseValidator` types in the `validators` field of that method. By default the [StatusCodeValidator](#statuscodevalidator) is passed.

#### StatusCodeValidator

The `StatusCodeValidator` is the default `ResponseValidator` used for requests made by the `RequestManager`. It checks if the status code of the response is betweeen the range that's passed to the initializer of the `StatusCodeValidator`, which by default is `200..<300`>.

#### Custom ResponseValidators

If you would like to create your own `ResponseValidator` type, just create a new type that conforms to the `ResponseValidator` protocol. For example a `ResponseValidator` that checks if the response data is not nil would look like this:

```swift
import Foundation
import SilverCommunication

struct DataValidator: ResponseValidator {

    enum Error: Swift.Error {
        case noData
    }

    func validate(response: Response<Data?>) throws {
        if data == nil {
            throw Error.noData
        }
    }
}
```

### Mocking

For test purposes, `RequestManager` supports response mocking in various ways:

#### URLResponse

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .response(URLResponse(), Data())
)
```

#### Data

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .data(Data("test".utf8), statusCode: 400)
)
```

#### Encodable

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

struct ResponseObject: Encodable {
    let value: String = "test"
}

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .encodable(ResponseObject())
)
```

#### File

The contents of `response.json`:

```json
{
    "key": "value"
}
```

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .file(name: "response", bundle: .main)
)
```

#### Bundle

File structure of `Mock.bundle`:

- GET
    - path
        - path.json
- POST:
    - path.json

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .bundle(name: "Mock", bundle: .main)
)
```

#### Error

```swift
let baseURL: URL = URL(string: "https://thiscouldbeanyurl.com")!

let requestManager = RequestManager(
    baseURL: baseURL,
    mockingMethod: .error(URLError(.notConnectedToInternet))
)
```