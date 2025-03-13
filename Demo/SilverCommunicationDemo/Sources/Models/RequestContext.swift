//
//  RequestContext.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import SilverCommunication

struct RequestContext {
    let path: String
    let httpMethod: Request.HTTPMethod
    var queryParameters: [String: String] = [String: String]()
    var headers: [String: String] = [String: String]()
    var httpBody: HTTPBody?
    
    var request: Request {
        Request(
            httpMethod: httpMethod,
            path: path,
            parameters: queryParameters,
            headers: headers,
            body: httpBody
        )
    }
}
