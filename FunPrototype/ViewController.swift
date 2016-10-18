//
//  ViewController.swift
//  FunPrototype
//
//  Created by SettradeMacbook on 10/11/2559 BE.
//  Copyright © 2559 settrade. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    var accountNo: String?
    var name: String?
    var provider = MoyaProvider<NetworkAPI>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name = "John Doe"
        requestAccountInfo(accountNo: "1234567")
    }

    func requestAccountInfo(accountNo: String) -> String {
        self.provider.request(.getAccount(accountNo)) { result in

                switch result {
                case let .success(response):
                    do {
                        if let json = try response.mapJSON() as? NSDictionary {
                            print(json)
                            self.createAccount(jsonAccount: json)
                        }
                    } catch {
                        
                    }
                case .failure(_):
                    break
                }
            }
        return ""
    }
    
    func createAccount(jsonAccount : NSDictionary) {
        name = jsonAccount["name"] as? String
        accountNo = jsonAccount["accountNo"] as? String
    }
}

