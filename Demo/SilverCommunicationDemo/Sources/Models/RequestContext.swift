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
    var queryParameters: [DictionaryItem] = []
    var headers: [DictionaryItem] = []
    var httpBody: HTTPBody?
    
    var request: Request {
        Request(
            httpMethod: httpMethod,
            path: path,
            parameters: queryParameters.dictionary,
            headers: headers.dictionary,
            body: httpBody
        )
    }
}
