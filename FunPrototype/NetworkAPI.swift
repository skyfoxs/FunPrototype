//
//  NetworkAPI.swift
//  FunPrototype
//
//  Created by SettradeMacbook on 10/11/2559 BE.
//  Copyright © 2559 settrade. All rights reserved.
//

import Foundation
import Moya

class NetworkAPI {
    var endpoint: String
    var service: NetworkService?
    var provider = MoyaProvider<NetworkAPI>()

    init(endpoint: String) {
        self.endpoint = endpoint
    }

    func get(_ service: NetworkService, completion: @escaping (Dictionary<String, Any>?)->()) {
        self.service = service
        provider.request(self) { result in
            switch result {
            case let .success(response):
                do {
                    if let json = try response.mapJSON() as? Dictionary<String, Any> {
                        completion(json)
                    }
                } catch {}
            case .failure(_):
                break
            }
        }
    }
}

enum NetworkService {
    case accountInfo(number: String)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        return URL(string: endpoint)!
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var path: String {
        return "/accountinfo"
    }
    
    var parameters: [String: Any]? {
        if let service = self.service {
            switch service {
            case .accountInfo(let number):
                return ["accountNo": number]
            }
        }
        return nil
    }
    var sampleData: Data {
        return Data()
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
