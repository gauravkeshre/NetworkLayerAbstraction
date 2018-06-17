//
//  NetworkAbstraction.swift
//  NetworkLayerAbstraction
//
//  Created by Gaurav Keshre on 30/05/18.
//  Copyright © 2018 Gaurav Keshre. All rights reserved.
//

import Foundation

/*****************/
/** ALIAS      ***/
/*****************/
public typealias JSONDictionary = [String: Any]


/*****************/
/** FUNCTIONS  ***/
/*****************/
public func HTTPURL(_ pathSegments: String...) -> String {
    return pathSegments.joined(separator: "/")
}

/*****************/
/** ENUMS      ***/
/*****************/

//MARK: HTTP METHODS
public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}


/*****************/
/** PROTOCOLS  ***/
/*****************/
//MARK: REQUEST
public protocol HTTPRequest{
    var identifier: String {get}
    var resource: HTTPResource {get}
}

public extension HTTPRequest {
    var identifier: String {
        return String(describing: Self.self)
    }
}

public struct JSON {
    let value: Any
    
    var dictionary: JSONDictionary? {
        return value as? JSONDictionary
    }
    
    var array: [JSONDictionary]? {
        return value as? [JSONDictionary]
    }
}

//MARK: RESPONSE
public protocol HTTPResponse {
    associatedtype Body
    var code: String? {get}
    var message: String? {get}
    var body: Body? {get}
    static func parse(dictionary: JSONDictionary) -> Self
}

/*****************/
/** MODELS      ***/
/*****************/

//MARK: RESOURCE
public struct HTTPResource{
    let path: String
    let method : HTTPMethod
    let headers : [String: Any]?
    let body: [String: Any]?
}

//MARK: ERROR
public struct HTTPError {
    let code: Int
    let domain: String?
    let message: String
    let description: String?
    //    let shouldRetry: Bool
}

extension  HTTPError {
    init(dictionary: JSONDictionary) {
        self.code = (dictionary["status"] as? Int ) ?? 400
        self.domain = (dictionary["domain"] as? String ) ?? nil
        self.message = (dictionary["message"] as? String ) ?? ""
        self.description = (dictionary["description"] as? String ) ?? nil
    }
    
    init(error: Error) {
        self.code = 0
        self.domain = nil
        self.message = ""
        self.description = ""
    }
}


typealias CompletionCallback<R: HTTPResponse> = (_ response: HTTResult<R>) -> ()

enum HTTResult<Reponse: HTTPResponse> {
    case failure(HTTPError)
    case success(Reponse)
}

protocol CancelableTask {
    func cancel()
}
