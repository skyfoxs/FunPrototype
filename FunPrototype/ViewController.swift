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
    var name: String?
    var accountNumber: String?

    var networkAPI = NetworkAPI(endpoint: "https://test.com")

    func requestAccountInfo(number: String) {
        networkAPI.get(.accountInfo(number: number)) {
            (data) in
            self.name = data?["name"] as? String
            self.accountNumber = data?["accountNumber"] as? String
        }
    }
}

