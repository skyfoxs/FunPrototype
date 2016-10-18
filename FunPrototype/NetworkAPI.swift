//
//  NetworkAPI.swift
//  FunPrototype
//
//  Created by SettradeMacbook on 10/11/2559 BE.
//  Copyright © 2559 settrade. All rights reserved.
//

import Foundation
import Moya

let MoyaEndpointClosure = { (target: NetworkAPI) -> Endpoint<NetworkAPI> in
    let endpoint: Endpoint<NetworkAPI> = Endpoint<NetworkAPI>(URL: url(target),
                                                      sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                                      method: target.method,
                                                      parameters: target.parameters).endpointByAddingHTTPHeaderFields(["Authorization": "Sense"])
    
    return endpoint
}


enum NetworkAPI {
    case getAccount(String)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://baseurl.com")!
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var path: String {
        return "/accountinfo"
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAccount(let accountNo):
            return ["accountNo":accountNo]
        }
    }
    var sampleData: Data {
        switch self {
        case .getAccount(let accountNo):
            if accountNo == "1234567"{
                return Data()
            }
            else {
                return Data()
            }
        }
    }
    var task:Task {
        return .request
    }
}


private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
