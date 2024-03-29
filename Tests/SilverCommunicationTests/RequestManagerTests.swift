//
//  RequestManagerTests.swift
//  SilverCommunicationTests
//
//  Created by Kjeld Groot on 14/09/2019.
//

import XCTest
import SilverCommunication

@testable import SilverCommunication

final class RequestManagerTests: XCTestCase {
    
    // MARK: - SUT
    
    private var sut: RequestManager!
    
    // MARK: - Private properties
    
    private var request: Request!
    private var data: Data!
    private var bundle: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: Self.self)
#endif
    }
    
    // MARK: - XCTestCase
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        request = Request(httpMethod: .get, path: "path")
        let json = """
        {
            "mockingMethod": "data"
        }
        """
        data = Data(json.utf8)
        let baseURL = try XCTUnwrap(URL(string: "https://github.com"))
        sut = RequestManager(baseURL: baseURL, mockingMethod: .data(data))
    }
    
    override func tearDown() {
        sut = nil
        data = nil
        request = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialProperties() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://github.com"))
        
        sut = RequestManager(baseURL: baseURL)
        XCTAssertEqual(sut.baseURL, baseURL)
        XCTAssertEqual(sut.urlSession, .shared)
        
        let customURLSession = URLSession(configuration: .default)
        sut = RequestManager(baseURL: baseURL, urlSession: customURLSession, defaultHeaders: nil)
        XCTAssertEqual(sut.baseURL, baseURL)
        XCTAssertEqual(sut.urlSession, customURLSession)
    }
    
    func testPerformRequest() async throws {
        let responseData = try await sut.perform(request: request)
        XCTAssertEqual(responseData, data)
    }
    
    func testPerformRequestWithParser() async throws {
        let response = try await sut.perform(request: request, parser: DictionaryParser<String, String>())
        let dictionary = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
        XCTAssertEqual(response, dictionary)
    }
    
    func testPerformRequestWithCompletionHandler() async throws {
        let responseData = try await withCheckedThrowingContinuation { continuation in
            sut.perform(request: request) { result in
                XCTAssert(Thread.isMainThread)
                continuation.resume(with: result)
            }
        }
        XCTAssertEqual(responseData, data)
    }
    
    func testPerformRequestWithErrorWithCompletionHandler() async throws {
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .error(URLError(.notConnectedToInternet)))
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                sut.perform(request: request) { result in
                    XCTAssert(Thread.isMainThread)
                    continuation.resume(with: result)
                }
            }
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, succeeded instead.")
        } catch URLError.notConnectedToInternet {} catch {
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testPerformRequestWithCompletionHandlerOnDifferentThread() async throws {
        let dispatchQueue = DispatchQueue(label: "Test")
        let responseData = try await withCheckedThrowingContinuation { continuation in
            sut.perform(request: request, callbackQueue: dispatchQueue) { result in
                XCTAssertFalse(Thread.isMainThread)
                DispatchQueue.main.async {
                    continuation.resume(with: result)
                }
            }
        }
        XCTAssertEqual(responseData, data)
    }
    
    func testPerformRequestWithCompletionHandlerWithParser() async throws {
        let response = try await withCheckedThrowingContinuation { continuation in
            sut.perform(request: request, parser: DictionaryParser<String, String>()) { result in
                XCTAssert(Thread.isMainThread)
                continuation.resume(with: result)
            }
        }
        let dictionary = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
        XCTAssertEqual(response, dictionary)
    }
    
    func testPerformRequestWithErrorWithCompletionHandlerWithParser() async throws {
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .error(URLError(.notConnectedToInternet)))
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                sut.perform(request: request, parser: DictionaryParser<String, String>()) { result in
                    XCTAssert(Thread.isMainThread)
                    continuation.resume(with: result)
                }
            }
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, succeeded instead.")
        } catch URLError.notConnectedToInternet {} catch {
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testPerformRequestWithCompletionHandlerWithParserOnDifferentThread() async throws {
        let dispatchQueue = DispatchQueue(label: "Test")
        let response = try await withCheckedThrowingContinuation { continuation in
            sut.perform(request: request, parser: DictionaryParser<String, String>(), callbackQueue: dispatchQueue) { result in
                XCTAssertFalse(Thread.isMainThread)
                DispatchQueue.main.async {
                    continuation.resume(with: result)
                }
            }
        }
        let dictionary = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
        XCTAssertEqual(response, dictionary)
    }
    
    func testPerformRequestWithError() async throws {
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .error(URLError(.notConnectedToInternet)))
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, succeeded instead.")
        } catch URLError.notConnectedToInternet {} catch {
            XCTFail("Expected perform(request:) to fail with URLError.notConnectedToInternet, failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testPerformRequestWithInvalidResponse() async throws {
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .response(nil))
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with RequestManagerError.invalidResponse, succeeded instead.")
        } catch RequestManagerError.invalidResponse {} catch {
            XCTFail("Expected perform(request:) to fail with RequestManagerError.invalidResponse, failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testPerformRequestWithInvalidStatusCode() async throws {
        let statusCode = 400
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .data(data, statusCode: statusCode))
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with StatusCodeValidatorError.invalidStatusCode(\(statusCode)), succeeded instead.")
        } catch StatusCodeValidatorError.invalidStatusCode(statusCode) {} catch {
            XCTFail("Expected perform(request:) to fail with StatusCodeValidatorError.invalidStatusCode(\(statusCode)), failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testPerformRequestWithMissingData() async throws {
        sut = RequestManager(baseURL: sut.baseURL, mockingMethod: .data(nil))
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with RequestManagerError.noData, succeeded instead.")
        } catch RequestManagerError.missingData {} catch {
            XCTFail("Expected perform(request:) to fail with RequestManagerError.noData, failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testDataMocking() async throws {
        let json = try await sut.perform(
            request: request,
            parser: DictionaryParser<String, String>()
        )
        XCTAssertEqual(json["mockingMethod"], "data")
    }
    
    func testBundleMocking() async throws {
        sut = RequestManager(
            baseURL: sut.baseURL,
            mockingMethod: .bundle(name: "Test", bundle: bundle)
        )
        let json = try await sut.perform(
            request: request,
            parser: DictionaryParser<String, String>()
        )
        XCTAssertEqual(json["mockingMethod"], "bundle")
        
        sut = RequestManager(
            baseURL: sut.baseURL,
            mockingMethod: .bundle(name: "Invalid", bundle: bundle)
        )
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with Bundle.ParsingError.fileNotFound(\"Invalid.bundle\"), succeeded instead.")
        } catch Bundle.ParsingError.fileNotFound("Invalid.bundle") {} catch {
            XCTFail("Expected perform(request:) to fail with Bundle.ParsingError.fileNotFound(\"Invalid.bundle\"), failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testFileMocking() async throws {
        sut = RequestManager(
            baseURL: sut.baseURL,
            mockingMethod: .file(name: "file", bundle: bundle)
        )
        let json = try await sut.perform(
            request: request,
            parser: DictionaryParser<String, String>()
        )
        XCTAssertEqual(json["mockingMethod"], "file")
        
        sut = RequestManager(
            baseURL: sut.baseURL,
            mockingMethod: .file(name: "invalid", bundle: bundle)
        )
        do {
            try await sut.perform(request: request)
            XCTFail("Expected perform(request:) to fail with Bundle.ParsingError.fileNotFound(\"invalid.json\"), succeeded instead.")
        } catch Bundle.ParsingError.fileNotFound("invalid.json") {} catch {
            XCTFail("Expected perform(request:) to fail with Bundle.ParsingError.fileNotFound(\"invalid.json\"), failed with \(String(reflecting: error)) instead.")
        }
    }
    
    func testEncodableMocking() async throws {
        sut = RequestManager(
            baseURL: sut.baseURL,
            mockingMethod: .encodable(EncodableObject(mockingMethod: "encodable"))
        )
        let json = try await sut.perform(
            request: request,
            parser: DictionaryParser<String, String>()
        )
        XCTAssertEqual(json["mockingMethod"], "encodable")
    }
}

private struct EncodableObject: Codable {
    let mockingMethod: String
}
