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
    - [HTTPBody](#httpbody)
        - [Binary](#binary)
        - [Multipart](#multipart)
        - [JSON](#json)
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
- [Demo app](#demo-app)
- [License](#license)


## Requirements

| Platform  | Version   |
| --------  | --------- |
| iOS       | 12.0+     | 
| macOS     | 10.13+    |
| tvOS      | 12.0+     |
| visionOS  | 1.0+      |
| watchOS   | 4.0+      |

## Installation

### Swift Package Manager

If you're using [Swift Package Manager](https://www.swift.org/documentation/package-manager/) to add `SilverCommunication` to your project's dependencies, you can add the package with Xcode using `File -> Add Package Dependencies...` and enter the GitHub url of the `SilverCode` project. If you need to add it to a project using a `Package.swift` file, add the following package and target dependencies:

```swift
let package = Package(
    ...
    // Package dependency
    dependencies: [
        .package(
            url: "https://github.com/kjeldGr/SilverCommunication.git", 
            .upToNextMinor(from: "0.14.1")
        )
    ],
    // Target dependency
    targets: [
        .target(
            ...
            dependencies: [
                "SilverCommunication"
            ]
        )
    ]
)
```

### CocoaPods

If you're using [CocoaPods](https://cocoapods.org) to add `SilverCommunication` to your project's dependencies, you can add the package by adding the following to your `Podfile`:

```ruby
# Make sure this line is present in your Podfile (it should be by default)
use_frameworks!

pod 'SilverCommunication', '~> 0.14.1'
```

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage) to add `SilverCommunication` to your project's dependencies, you can add the package by adding the following to your `Cartfile`:

```
github "kjeldGr/SilverCommunication" ~> 0.14.1
```

## Usage

### RequestManager

To perform HTTP requests with `SilverCommunication` a `RequestManager` instance will be used. The main goal of using this object is making sure all connections to the same server are handled in the same way. Creating an instance of the `RequestManager` is done by passing the base URL of the server that it will communicate with:

```swift
import SilverCommunication

let urlString = "https://httpbin.org"
var requestManager = RequestManager(baseURL: URL(string: urlString)!)

// The base URL can also be passed as String value, however the initializer raises an Error when the String has an invalid URL format
do {
    requestManager = try RequestManager(baseURL: urlString)
} catch {
    // Handle error
}
```

#### Perform request

After creating the `RequestManage`, it can be used to perform HTTP requests using the [Request](#request) model.

```swift
import Foundation
import SilverCommunication

let requestManager = RequestManager(baseURL: URL(string: "https://httpbin.org")!)
let request = Request(path: "/get")

// Async await
func performRequest() async throws -> Data? {
    let response = try await requestManager.perform(request: request)
    
    debugPrint(response.statusCode) // 200
    debugPrint(response.headers) // `[String: String]` value of the response headers
    debugPrint(response.content) // Optional `Data` value with the content of the response
    
    return data
}

// Completion handler
func performRequest(completion: @escaping (Result<Data?, Error>) -> Void) {
    requestManager.perform(request: request) { result in
        do {
            let response = try result.get()
            
            debugPrint(response.statusCode) // 200
            debugPrint(response.headers) // `[String: String]` value of the response headers
            debugPrint(response.content) // Optional `Data` value with the content of the response
            
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}
```

#### Parsing

`Parser` types can be used to directly parse the response when the request is finished. Various `Parser` types are by default available within the `SilverCommunication` project, but custom `Parser` types can be created within your own project. For more details on parsing check the [Parser](#parser) documentation.

```swift
import Foundation
import SilverCommunication

struct Item: Decodable {
    let url: URL
}

func fetchItem() async throws -> Item {
    let requestManager = try RequestManager(baseURL: "https://httpbin.org")
    return try await requestManager.perform(
        request: Request(path: "/get"),
        parser: DecodableParser()
    ).content
}
```

#### RequestManager as EnvironmentObject

The `RequestManager` class conforms to the `ObservableObject` protocol which allows you to pass the `RequestManager` instance as an `EnvironmentObject` through your `SwiftUI` applications. An example implementation would look something like this:

```swift
import SilverCommunication
import SwiftUI

@main
struct SilverCommunicationApp: App {
    @State private var requestManager: RequestManager = RequestManager(
        baseURL: URL(string: "https://httpbin.org")!
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(requestManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var requestManager: RequestManager
    @State private var rawResponse: String?

    var body: some View {
        VStack {
            if let rawResponse {
                Text(rawResponse)
            }
            Button("Perform request", action: performRequest)
        }
    }

    private func performRequest() {
        Task {
            do {
                let response = try await requestManager.perform(
                    request: Request(path: "/get")
                )
                rawResponse = response.content.flatMap { 
                    String(decoding: $0, as: UTF8.self) 
                }
            } catch {
                // Handle error
            }
        }
    }
}
```

### Request

The `Request` model contains all properties related to the specific request to the server. Some examples of how to configure it is shown below. For detailed documentation on passing a HTTP body to the request, see [HTTPBody](#httpbody).

```swift
import SilverCommunication

// GET request with a path and query parameters (GET is the default HTTP method)
var request = Request(
    path: "/get",
    parameters: ["key": "value"]
)

// POST request with custom headers and a Dictionary (JSON) body
do {
    request = Request(
        httpMethod: .post,
        path: "/post",
        headers: [
            .authorization: "Basic <credentials>"
        ],
        // Content-Type application/json header will be added automatically when using this type of body
        body: try HTTPBody(jsonObject: ["Key": "Value"])
    )
} catch {
    // Handle error
}

// PUT request with an Encodable (JSON) body
struct BodyItem: Identifiable, Encodable {
    let id: Int
}

do {
    request = Request(
        httpMethod: .put,
        path: "/put",
        // Content-Type application/json header will be added automatically when using this type of body
        body: try HTTPBody(encodable: BodyItem(id: 1))
    )
} catch {
    // Handle error
}
```

### HTTPBody

The `HTTPBody` enum type can be used to add a HTTP body to the `Request`. The correct `"Content-Type"` header will be added automatically, unless you decide to overwrite it in the `Request` properties.

#### Binary

The `HTTPBody.binary` is used to add a `Binary` instances content as HTTP body for the request and can be used like:

```swift
import SilverCommunication

let data = Data("text".utf8)
var body = HTTPBody.binary(Binary(data: data, contentType: .text))

// Or with a convenience initializer
body = HTTPBody(data: data, contentType: .text)
```

#### Multipart

The `HTTPBody.multipart` is used to perform multipart requests. The  and can be used like:

```swift
import SilverCommunication

let body = HTTPBody.multipart(MultipartRequestBody(
    items: [
        MultipartItem(text: "text", name: "text"),
        MultipartItem(
            binary: Binary(
                data: Data("{\"key\": \"value\"}".utf8), 
                contentType: .json
            ),
            name: "json"
        )
    ]
))
```

#### JSON

`HTTPBody` contains convenience initializers for JSON content that can be used like:

```swift
import SilverCommunication

do {
    let body = try HTTPBody(jsonObject: ["key": "value"])
} catch {
    // Handle error
}

do {
    let body = try HTTPBody(jsonObject: ["value1", "value2"])
} catch {
    // Handle error
}

struct EncodableBody: Encodable {
    let id: Int
}
do {
    // Additionally you could add a custom JSONEncoder
    let body = try HTTPBody(encodable: EncodableBody(id: 0))
} catch {
    // Handle error
}
```

### Parser

`Parser` types can be used to map a `Response` instance with `Data` type content to the expected type. The best use case for the `Parser` is to pass it to a `RequestManager` instance when performing a request. Below you can find some examples about the usage of the default `Parser` implementations.

For these examples, we assume the response content looks something like:

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

#### ArrayParser

The `ArrayParser` can be used to parse an `Array` type from a JSON response. The `Element` is a generic type, so it's possible to parse all sorts of `Array` values.

```swift
import SilverCommunication

do {
    let requestManager = try RequestManager(baseURL: "https://httpbin.org")
    // Parsing a (JSON) dictionary from the response (key path is optional)
    let response = try await requestManager.perform(
        request: Request(path: "/get"),
        parser: ArrayParser<[String: Any]>(keyPath: "users")
    )
    debugPrint(response.content) // [["id": 1, "username": "Jules"], ["id": 2, "username": "Vincent"]]
} catch {
    // Handle error
}
```

#### DecodableParser

The `DecodableParser` can be used to parse any `Decodable` type from a JSON response.

```swift
import SilverCommunication

struct User: Identifiable, Decodable {
    let id: Int
    let username: String
}

do {
    let requestManager = try RequestManager(baseURL: "https://httpbin.org")
    // Parsing a (JSON) dictionary from the response (key path is optional)
    let response = try await requestManager.perform(
        request: Request(path: "/get"),
        parser: DecodableParser<[User]>(keyPath: "users")
    )
    debugPrint(response.content) // [User(id: 1, username: "Jules"), User(id: 2, username: "Vincent")]
} catch {
    // Handle error
}
```

#### DictionaryParser

The `DictionaryParser` can be used to parse a `Dictionary` from a JSON response. The `Key` and `Value` are generic types, so it's possible to parse all sorts of dictionaries as long as the `Key` type conforms to `Hashable`.

```swift
import SilverCommunication

do {
    let requestManager = try RequestManager(baseURL: "https://httpbin.org")
    // Parsing a (JSON) dictionary from the response (key path is optional)
    let response = try await requestManager.perform(
        request: Request(path: "/get"),
        parser: DictionaryParser<String, Any>()
    )
    debugPrint(response.content) // ["version": 1.0, "users": [["id": 1, "username": "Jules"], ["id": 2, "username": "Vincent"]]]
} catch {
    // Handle error
}
```

#### Custom Parsers

If you would like to create your own `Parser` type, just create a new type that conforms to the `Parser` protocol. For example a `Parser` that decodes a `Base-64` encoded `Data` value could look something like:

```swift
import Foundation
import SilverCommunication

struct Base64Parser: Parser {
    func parse(response: Response<Data>) throws -> Response<Data> {
        try response.map { content in
            guard let decodedData = Data(base64Encoded: content) else {
                throw ValueError.invalidValue(
                    content,
                    context: ValueError.Context(keyPath: \Response<ContentType>.content)
                )
            }
            return decodedData
        }
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
    func validate(response: Response<Data?>) throws {
        if response.content == nil {
            throw ValueError.missingValue(
                context: ValueError.Context(keyPath: \Response<Data?>.content)
            )
        }
    }
}
```

### Mocking

For test purposes, `RequestManager` supports response mocking in various ways:

#### URLResponse

The `urlResponse` mocking type supports passing a `URLResponse` instance which will be returned in the `perform(request:)` method of the `RequestManager`. Optionally you could provide a `Data` value which will be included as the response content.

```swift
import SilverCommunication

do {
    let baseURL = URL(string: "anyURLIsFineHere")!
    let requestManager = try RequestManager(
        baseURL: baseURL,
        mockingMethod: .response(
            HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil),
            data: Data("test".utf8)
        )
    )
    let response = try await requestManager.perform(
        request: Request(path: "/any")
    )
    debugPrint(response.content.flatMap { String(decoding: $0, as: UTF8.self) }) // Optional("test")
} catch {
    // Handle error
}
```

#### Data

The `data` mocking type supports passing an optional `Data` value which will be returned in the `perform(request:)` method of the `RequestManager`. Optionally you can add a `statusCode` value, which by default is set to 200.

```swift
import SilverCommunication

do {
    let requestManager = try RequestManager(
        baseURL: "anyURLIsFineHere",
        mockingMethod: .data(Data("test".utf8))
    )
    let response = try await requestManager.perform(
        request: Request(path: "/any")
    )
    debugPrint(response.content.flatMap { String(decoding: $0, as: UTF8.self) }) // Optional("test")
} catch {
    // Handle error
}
```

#### Encodable

The `encodable` mocking type supports passing an `Encodable` instance which will be returned in the `perform(request:)` method of the `RequestManager`. Optionally you can add a custom `JSONEncoder`, which by default is set to `JSONEncoder()`, and a `statusCode` value, which by default is set to 200.

```swift
import SilverCommunication

struct ResponseObject: Codable {
    let key: String
}

do {
    let requestManager = try RequestManager(
        baseURL: "anyURLIsFineHere",
        mockingMethod: .encodable(ResponseObject(key: "value"))
    )
    let response = try await requestManager.perform(
        request: Request(path: "/any"),
        parser: DecodableParser<ResponseObject>()
    )
    debugPrint(response.content) // ResponseObject(key: "value")
} catch {
    // Handle error
}
```

#### File

The `file` mocking type supports passing a file name (and the `Bundle` that contains the file) of which the content will be returned in the `perform(request:)` method of the `RequestManager`. Optionally you can add a custom `fileExtension`, which by default is set to `"json"`, and a `statusCode` value, which by default is set to 200.

An example where the contents of `response.json` are:

```json
{
    "key": "value"
}
```

```swift
import SilverCommunication

struct ResponseObject: Decodable {
    let key: String
}

do {
    let requestManager = try RequestManager(
        baseURL: "anyURLIsFineHere",
        mockingMethod: .file(name: "response", bundle: .main)
    )
    let response = try await requestManager.perform(
        request: Request(path: "/any"),
        parser: DecodableParser<ResponseObject>()
    )
    debugPrint(response.content) // ResponseObject(key: "value")
} catch {
    // Handle error
}
```

#### Bundle

The `bundle` mocking type supports passing a bundle name (and the `Bundle` that contains the file) of which the contents will be used in the `perform(request:)` method of the `RequestManager`. The bundle should contain directories for the HTTP methods that are used (e.g. `"GET"`) and have the folder structure which aligns with the performed requests.

Example file structure of `Mock.bundle`:

- GET
    - mock
        - data.json
- POST:
    - path.json

```swift
import SilverCommunication

do {
    let requestManager = try RequestManager(
        baseURL: "anyURLIsFineHere",
        mockingMethod: .bundle(name: "Mock", bundle: .main)
    )
    // Response will contain the content from GET/mock/data.json in Mock.bundle
    var response = try await requestManager.perform(
        request: Request(path: "/mock/data")
    )
    // Response will contain the content from POST/path.json in Mock.bundle
    response = try await requestManager.perform(
        request: Request(httpMethod: .post, path: "/path")
    )
    // Will result in FileError.fileNotFound("GET/unknown.json")
    response = try await requestManager.perform(
        request: Request(httpMethod: .put, path: "/unknown")
    )
} catch {
    // Handle error
}
```

A more detailed example on how to use the `bundle` mocking can be found in the [Demo app](#demo-app).

#### Error

The `error` mocking type supports passing an `Error` type which will be raised in the `perform(request:)` method of the `RequestManager`.

```swift
import Foundation
import SilverCommunication

do {
    let requestManager = try RequestManager(
        baseURL: "anyURLIsFineHere",
        mockingMethod: .error(URLError(.notConnectedToInternet))
    )
    try await requestManager.perform(request: Request(path: "/path"))
} catch {
    debugPrint(error) // Foundation.URLError(_nsError: Error Domain=NSURLErrorDomain Code=-1009 "(null)")
}
```

## Demo app

`SilverCommunicationDemo` is a multiplatform application which can be found in the `Demo` directory of the project source. It showcases fetching data from multiple APIs, including mocking examples and examples on how to parse the response to `Decodable` types.

## License

`SilverCommunication` is released under the MIT license. See [LICENSE](https://github.com/kjeldGr/SilverCommunication/blob/main/LICENSE) for more details.