//
//  FunPrototypeTests.swift
//  FunPrototypeTests
//
//  Created by SettradeMacbook on 10/11/2559 BE.
//  Copyright © 2559 settrade. All rights reserved.
//

import XCTest

@testable import FunPrototype
@testable import Moya
@testable import Result

extension NetworkService {
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
}

class FunPrototypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetAccountNameWithAccountNo3254120ShouldReturnJohnDoe(){
        // arrange
        let viewcontroller = ViewController()
        let endpointClosure = { (target: NetworkService) -> Endpoint<NetworkService> in
            let endpoint: Endpoint<NetworkService> = Endpoint<NetworkService>(
                    URL: target.baseURL.absoluteString,
                    sampleResponseClosure: {
                        .networkResponse(200, "{\"accountNo\": \"3254120\", \"name\": \"John Doe\"}".data(using: String.Encoding.utf8)!)
                    },
                    method: target.method,
                    parameters: target.parameters)
            return endpoint
        }
        
        viewcontroller.provider = MoyaProvider<NetworkService>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)
        
        // act
        _ = viewcontroller.requestAccountInfo(accountNo: "3254120")
        XCTAssertEqual(viewcontroller.name, "John Doe")
    }
    
    func testGetAccountNameWithAccountNo1234567ShouldReturnMaryZoo () {
        // arrange
        let viewcontroller = ViewController()
        let endpointClosure = { (target: NetworkService) -> Endpoint<NetworkService> in
            let endpoint: Endpoint<NetworkService> = Endpoint<NetworkService>(
                    URL: target.baseURL.absoluteString,
                    sampleResponseClosure: {
                        .networkResponse(200, "{\"accountNo\": \"1234567\", \"name\": \"Mary Zoo\"}".data(using: String.Encoding.utf8)!)
                    },
                    method: target.method,
                    parameters: target.parameters)
            return endpoint
        }
        
        viewcontroller.provider = MoyaProvider<NetworkService>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)
        
        // act
        _ = viewcontroller.requestAccountInfo(accountNo: "1234567")
        
        // assert
        XCTAssertEqual(viewcontroller.name, "Mary Zoo")
    }

    func testGetAccountNameExpectURLAndHeader() {

        let endpointClosure = { (target: NetworkService) -> Endpoint<NetworkService> in
            let endpoint: Endpoint<NetworkService> = Endpoint<NetworkService>(
                    URL: url(target),
                    sampleResponseClosure: {
                        .networkResponse(200, target.sampleData)
                    },
                    method: target.method,
                    parameters: target.parameters)
                .endpointByAddingHTTPHeaderFields(["Authorization": "Sense"])
            return endpoint
        }
        // arrange
        var expectedURL : String!
        var expectedAuthorizationHeader : String!
        
        let plugin = TestMoyaPlugin { result,status in
            expectedURL = result.request?.url?.absoluteString
            expectedAuthorizationHeader = result.request?.allHTTPHeaderFields?["Authorization"]
        }
        
        let viewcontroller = ViewController()
        
        viewcontroller.provider = MoyaProvider<NetworkService>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub, plugins:[plugin])
        
        // act
        _ = viewcontroller.requestAccountInfo(accountNo: "1234567")
        
        // assert
        XCTAssertEqual(expectedURL, "https://baseurl.com/accountinfo?accountNo=1234567")
        XCTAssertEqual(expectedAuthorizationHeader, "Sense")
    }

    public enum NetworkActivityChangeType {
        case began, ended
    }

    public final class TestMoyaPlugin: PluginType {

        public typealias NetworkActivityClosure = (_ request: RequestType,_ change: NetworkActivityChangeType) -> ()
        let networkActivityClosure: NetworkActivityClosure

        public init(networkActivityClosure: @escaping NetworkActivityClosure) {
            self.networkActivityClosure = networkActivityClosure
        }

        // MARK: Plugin

        public func willSendRequest(_ request: RequestType, target: TargetType) {
            networkActivityClosure(request,.began)
        }

        public func didReceiveResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType) {
            
        }
    }
}
