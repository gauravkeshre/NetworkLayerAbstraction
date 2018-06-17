//
//  APIManager.swift
//  NetworkLayerAbstraction
//
//  Created by Gaurav Keshre on 30/05/18.
//  Copyright © 2018 Gaurav Keshre. All rights reserved.
//

import Foundation
import Swifty

/** Swifty */
class SwiftyAPIManager: WebService {
    static var serverURL: String = APIEnvironment.current.url
    static var networkInterface: WebServiceNetworkInterface = Swifty(requestInterceptors: [SwiftyRequestInterceptor()])
    
}

/** RequestInterceptor */
class SwiftyRequestInterceptor: RequestInterceptor {
    
    func intercept(resource: NetworkResource) -> NetworkResource {
        resource.header(key: "device_id", value: "asdasdasdasdasda")
        resource.header(key: "auth_token", value: "1231321123123")
        return resource
    }
}




final class API {
    
    //MARK:- AUTH Methods
    @discardableResult
    static func  loginUser(username: String, password: String,
                           onCompletion: @escaping CompletionCallback<LoginResponse>) -> CancelableTask? {
        
        let request = LoginRequest(username: username,
                                   password: password)
        return  SendRequest(request: request) { (res: HTTResult<LoginResponse>) in
            onCompletion(res)
        }
    }
}

