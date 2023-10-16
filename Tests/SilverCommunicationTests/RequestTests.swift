//
//  RequestTests.swift
//  SilverCommunicationTests
//
//  Created by Kjeld Groot on 08/11/2019.
//

import XCTest

@testable import SilverCommunication

final class RequestTests: XCTestCase {
    
    // MARK: - Private properties
    
    private var baseURL: URL!
    
    // MARK: - Internal methods
    
    // MARK: XCTestCase
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.baseURL = try XCTUnwrap(URL(string: "https://github.com"))
    }
    
    override func tearDown() {
        baseURL = nil
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testRequestInitializer() {
        let httpMethod = Request.HTTPMethod.get
        let path = "path"
        let request = Request(httpMethod: httpMethod, path: path)
        
        XCTAssertEqual(request.httpMethod, httpMethod)
        XCTAssertEqual(request.path, path)
        XCTAssertNil(request.headers)
        XCTAssertNil(request.body)
        
        let headers = ["User-Agent": "This is the user agent"]
        let requestWithHeaders = Request(httpMethod: httpMethod, path: path, headers: headers)
        XCTAssertEqual(requestWithHeaders.httpMethod, httpMethod)
        XCTAssertEqual(requestWithHeaders.path, path)
        XCTAssertEqual(requestWithHeaders.headers, headers)
        XCTAssertNil(request.body)
        
        let body = Request.HTTPBody.dictionary(["id": 1])
        let requestWithHeadersAndContent = Request(
            httpMethod: httpMethod,
            path: path,
            headers: headers,
            body: body
        )
        XCTAssertEqual(requestWithHeadersAndContent.httpMethod, httpMethod)
        XCTAssertEqual(requestWithHeadersAndContent.path, path)
        XCTAssertEqual(requestWithHeadersAndContent.headers, headers)
        XCTAssertEqual(requestWithHeadersAndContent.body, body)
    }
    
    func testInitializeURLRequest() throws {
        let path = "path"
        let request = Request(path: path)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/\(path)")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestMethod() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let request = Request(httpMethod: httpMethod, path: path)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/\(path)")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithPathInBaseURL() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let request = Request(httpMethod: httpMethod, path: path)
        
        let urlRequest = try URLRequest(baseURL: baseURL.appendingPathComponent("test"), request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/test/\(path)")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestWithParameters() throws {
        let path = "path"
        let parameters = ["id": 1]
        let request = Request(path: path, parameters: parameters)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertEqual(urlComponents.queryItems, [URLQueryItem(name: "id", value: "1")])
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestWithParametersInPath() throws {
        let path = "path?id=1"
        let request = Request(path: path)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertEqual(urlComponents.queryItems, [URLQueryItem(name: "id", value: "1")])
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestWithParametersInPathWithParameters() throws {
        let path = "path?id=1"
        let request = Request(path: path, parameters: ["test": "test"])
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertEqual(urlComponents.queryItems, [
            URLQueryItem(name: "id", value: "1"),
            URLQueryItem(name: "test", value: "test")
        ])
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestWithHeaders() throws {
        let path = "path"
        let headers = ["test": "test"]
        let request = Request(path: path, headers: headers)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["test": "test"])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeURLRequestWithRequestWithDataBody() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let data = Data("Test".utf8)
        let request = Request(httpMethod: httpMethod, path: path, body: .data(data))
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        XCTAssertEqual(urlRequest.httpBody, data)
    }
    
    func testInitializeURLRequestWithRequestWithDictionaryBody() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let parameters = ["id": 1]
        let body = Request.HTTPBody.dictionary(parameters)
        let request = Request(httpMethod: httpMethod, path: path, body: body)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [.contentType: "application/json"])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        try XCTAssertEqual(urlRequest.httpBody, JSONSerialization.data(withJSONObject: parameters))
    }
    
    func testInitializeURLRequestWithRequestWithDictionaryBodyWithCustomContentType() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let headers = [Request.Header.contentType: "text/html"]
        let parameters = ["id": 1]
        let body = Request.HTTPBody.dictionary(parameters)
        let request = Request(httpMethod: httpMethod, path: path, headers: headers, body: body)
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [.contentType: "text/html"])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        try XCTAssertEqual(urlRequest.httpBody, JSONSerialization.data(withJSONObject: parameters))
    }
    
    func testInitializeURLRequestWithRequestWithEncodableBody() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let encodable = CodableObject(id: "id", title: "title")
        let request = Request(httpMethod: httpMethod, path: path, body: .encodable(encodable))
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [.contentType: "application/json"])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        try XCTAssertEqual(urlRequest.httpBody, JSONEncoder().encode(encodable))
    }
    
    func testInitializeURLRequestWithRequestWithEncodableBodyWithCustomContentType() throws {
        let httpMethod = Request.HTTPMethod.post
        let path = "path"
        let headers = [Request.Header.contentType: "text/html"]
        let encodable = CodableObject(id: "id", title: "title")
        let request = Request(httpMethod: httpMethod, path: path, headers: headers, body: .encodable(encodable))
        
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertNil(urlComponents.queryItems)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [.contentType: "text/html"])
        XCTAssertEqual(urlRequest.httpMethod, httpMethod.rawValue)
        try XCTAssertEqual(urlRequest.httpBody, JSONEncoder().encode(encodable))
    }
    
    func testSlashIsAppendedToPath() throws {
        try ["path", "/path"].forEach { path in
            let request = Request(httpMethod: .get, path: path)
            let urlRequest = try URLRequest(baseURL: baseURL, request: request)
            XCTAssertEqual(urlRequest.url?.absoluteString, "\(baseURL.absoluteString)/path")
        }
    }
    
    func testPercentEncodingQueryItems() throws {
        let parameter = "ThisIsA+Parameter"
        let request = Request(path: "/path", parameters: (["parameter": parameter]))
        let urlRequest = try URLRequest(baseURL: baseURL, request: request)
        
        let encodedParameter = try XCTUnwrap(parameter.addingPercentEncoding(withAllowedCharacters: .alphanumerics))
        let urlComponents = try XCTUnwrap(urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        })
        XCTAssertEqual(urlComponents.baseURL, baseURL)
        XCTAssertEqual(urlComponents.path, "/path")
        XCTAssertEqual(urlComponents.queryItems, [URLQueryItem(name: "parameter", value: parameter)])
        XCTAssertEqual(urlComponents.percentEncodedQueryItems, [URLQueryItem(name: "parameter", value: encodedParameter)])
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, [:])
        XCTAssertEqual(urlRequest.httpMethod, Request.HTTPMethod.get.rawValue)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testInitializeGetURLRequestWithInvalidPath() throws {
        let httpMethod = Request.HTTPMethod.get
        let path = "{}"
        let request = Request(httpMethod: httpMethod, path: path)
        
        try XCTAssertThrowsError(URLRequest(baseURL: baseURL, request: request)) { error in
            switch error {
            case URLRequest.Error.invalidURL:
                break
            default:
                XCTFail("Expected initializer to fail with Request.Error.invalidURL, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testHTTPBody() {
        let dataBody = Request.HTTPBody.data(Data())
        XCTAssertEqual(dataBody, dataBody)
        let otherDataBody = Request.HTTPBody.data(Data("Test".utf8))
        XCTAssertNotEqual(dataBody, otherDataBody)
        
        let dictionaryBody = Request.HTTPBody.dictionary(["Test": "Test"])
        XCTAssertEqual(dictionaryBody, dictionaryBody)
        let otherDictionaryBody = Request.HTTPBody.dictionary(["Test": "Other"])
        XCTAssertNotEqual(dictionaryBody, otherDictionaryBody)
        
        let encodableBody = Request.HTTPBody.encodable(CodableObject(id: "id", title: "title"))
        XCTAssertEqual(encodableBody, encodableBody)
        let otherEncodableBody = Request.HTTPBody.encodable(CodableObject(id: "id", title: "other"))
        XCTAssertNotEqual(encodableBody, otherEncodableBody)
        
        XCTAssertNotEqual(dataBody, dictionaryBody)
        XCTAssertNotEqual(dataBody, encodableBody)
        XCTAssertNotEqual(dictionaryBody, encodableBody)
    }
}

private extension URLComponents {
    var baseURL: URL? {
        scheme.flatMap { scheme in
            host.flatMap { host in
                URL(string: "\(scheme)://\(host)")
            }
        }
    }
}
