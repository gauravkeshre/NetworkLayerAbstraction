//
//  Signup.swift
//  NetworkLayerAbstractionDemo
//
//  Created by Gaurav Keshre on 19/06/18.
//  Copyright © 2018 Zoomcar. All rights reserved.
//

import Foundation


/*****************/
/** MODEL  ***/
/*****************/


struct Signup {
	let id: String
	init?(_ dictionary: JSONDictionary) {
		guard let iid = dictionary["id"] as? String else { return nil }

		id = iid
	}
}

/*****************/
/** RESPONSE  ***/
/*****************/


struct SignupResponse: HTTPResponse {
		typealias Body = Signup

    var code: String?

    var message: String?

    var body: Body?

    static func parse(dictionary: JSONDictionary) -> SignupResponse {
        let body: Body?

        if let _body = dictionary["<# name #>"] as? [JSONDictionary] {
					body = _body.flatMap{SignupResponse($0)}
        }else {
          body = nil
        }

        return SignupResponse(code: dictionary["code"] as? String,
                            message: dictionary["message"] as? String,
                            body: body)
    }

}

/*****************/
/** REQUEST    ***/
/*****************/

struct SignupRequest: HTTPRequest {
    private var params: [String: Any] = [:]

    init() {
        self.params [ API.K.deviceId] = SessionManager.instance.deviceId
    }

    var resource: HTTPResource {
        let authResource = HTTPResource(path: APIEndpoints.<#API ENDPOINT#>, method: .<#get#>, headers: [:], body: params)
        return authResource
    }
}
