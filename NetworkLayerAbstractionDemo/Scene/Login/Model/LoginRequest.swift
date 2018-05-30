//
//  Login.swift
//  NetworkLayerAbstractionDemo
//
//  Created by Gaurav Keshre on 30/05/18.
//  Copyright © 2018 Zoomcar. All rights reserved.
//

import Foundation


/*****************/
/** MODEL  ***/
/*****************/

struct User {
	let id: String
    let name: String?
	init?(_ dictionary: JSONDictionary) {
		guard let iid = dictionary["id"] as? String else { return nil }
        id = iid
        name = dictionary["name"] as? String
	}
}

/*****************/
/** RESPONSE  ***/
/*****************/


struct LoginResponse: HTTPResponse {
    typealias Body = User

    var code: String?

    var message: String?

    var body: Body?

    static func parse(dictionary: JSONDictionary) -> LoginResponse {
        let body: Body? = User(dictionary)

        return LoginResponse(code: dictionary["code"] as? String,
                            message: dictionary["message"] as? String,
                            body: body)
    }

}

/*****************/
/** REQUEST    ***/
/*****************/

struct LoginRequest: HTTPRequest {
    private var params: [String: Any] = [:]

    init(username: String, password: String) {
        params["username"] = username
        params["pass"] = password
        params["is_social_login"] = "0"
    }

    var resource: HTTPResource {
        let authResource = HTTPResource(path: APIEndpoints.login, method: .get, headers: [:], body: params)
        return authResource
    }
}
