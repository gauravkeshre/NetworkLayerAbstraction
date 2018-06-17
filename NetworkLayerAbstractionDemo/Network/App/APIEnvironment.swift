//
//  APIEnvironment.swift
//  NetworkLayerAbstraction
//
//  Created by Gaurav Keshre on 30/05/18.
//  Copyright © 2018 Gaurav Keshre. All rights reserved.
//

import Foundation
/** Network Model */
enum APIEnvironment {
    case live, stage, dev, mock
    var url: String {
        switch self {
        case .live:     return "https://www.mocky.io/v2"
        case .stage:    return "https://www.mocky.io/v2"
        case .dev:      return "https://www.mocky.io/v2"
        case .mock:     return "http://www.mocky.io/v2"
        }
    }
}

extension APIEnvironment {
    static var current: APIEnvironment {
        return .mock
    }
}

struct APIEndpoints {
    ///Onboarding
    static let config               = "59f4bdf73100005e005b86da"
    
    ///USER
    static let login                = "59f4bdf73100005e005b86da" // "login"
    static let register             = "59f4bdf73100005e005b86da"
}
