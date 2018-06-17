//
//  NetworkRequestSender.swift
//  NetworkLayerAbstraction
//
//  Created by Gaurav Keshre on 30/05/18.
//  Copyright © 2018 Gaurav Keshre. All rights reserved.
//

import Foundation
import Swifty


extension NetworkResource : CancelableTask {
    func cancel() {
        
    }
}

func SendRequest<R: HTTPRequest, T>(request: R,
                                    showHUD: Bool = true,
                                    onCompletion completion: @escaping CompletionCallback<T>
    ) -> CancelableTask? {
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    var nRes: NetworkResource = request.resource.method == .get ? SwiftyAPIManager.server.get(request.resource.path) : SwiftyAPIManager.server.post(request.resource.path)
    
    if let body = request.resource.body {
        nRes = nRes.query(body)
    }
    
    print(nRes.printDetails())
    nRes.load { (response) in
        HandleResponse(response: response, showHUD: showHUD, onCompletion: completion)
    }
    
    return nRes
}


func HandleResponse<T>(response: NetworkResponse ,
                       showHUD: Bool = true,
                       onCompletion completion: @escaping CompletionCallback<T>){
    
    let handleCompletion = {(_ response: HTTResult<T>) -> () in
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(response)
        }
    }
    
    func handleArbitoryError() {
        let err = HTTPError(code: 1000, domain: nil, message: "Something went wrong!", description: "Please try again later")
        let rs = HTTResult<T>.failure(err)
        handleCompletion(rs)
    }
    
    if let err = response.error {
        let hherr = HTTPError(error: err)
        let rs = HTTResult<T>.failure(hherr)
        handleCompletion(rs)
        return
    }
    
    let dictionary: JSONDictionary!
    
    do {
        dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONDictionary
    }catch {
        handleArbitoryError()
        return
    }
    
    if let status = dictionary["status"] as? Bool, status == false {
        let err = HTTPError(dictionary: dictionary)
        let rs = HTTResult<T>.failure(err)
        handleCompletion(rs)
        return
    }
    
    guard let body = dictionary["body"] as? JSONDictionary else{
        handleArbitoryError()
        return
    }
    
    let rs = HTTResult<T>.success(T.parse(dictionary: body))
    handleCompletion(rs)
}
