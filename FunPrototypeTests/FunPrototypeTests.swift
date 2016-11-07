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

    var mockEndpointClosure: ((_ target: NetworkAPI) -> Endpoint<NetworkAPI>)!

    override func setUp() {
        super.setUp()

        mockEndpointClosure = { (target: NetworkAPI) -> Endpoint<NetworkAPI> in
            let endpoint: Endpoint<NetworkAPI> = Endpoint<NetworkAPI>(
                URL: target.baseURL.absoluteString,
                sampleResponseClosure: {
                    let response: String
                    if let number = target.parameters?["accountNo"] as? String, number == "3254120"{
                        response = "{\"accountNo\": \"3254120\", \"name\": \"John Doe\"}"
                    } else {
                        response = "{\"accountNo\": \"1234567\", \"name\": \"Mary Zoo\"}"
                    }
                    return .networkResponse(200, response.data(using: String.Encoding.utf8)!)
                },
                method: target.method,
                parameters: target.parameters)
            return endpoint
        }
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testGetAccountNameWithAccountNo3254120ShouldReturnJohnDoe(){
        let viewcontroller = ViewController()
        let networkAPI = NetworkAPI(endpoint: "https://baseurl.com")
        
        networkAPI.provider = MoyaProvider<NetworkAPI>(endpointClosure: mockEndpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)
        viewcontroller.networkAPI = networkAPI

        _ = viewcontroller.requestAccountInfo(number: "3254120")

        XCTAssertEqual(viewcontroller.name, "John Doe")
    }


    func testGetAccountNameWithAccountNo1234567ShouldReturnMaryZoo () {
        let viewcontroller = ViewController()
        let networkAPI = NetworkAPI(endpoint: "https://baseurl.com")

        networkAPI.provider = MoyaProvider<NetworkAPI>(endpointClosure: mockEndpointClosure, stubClosure: MoyaProvider.ImmediatelyStub)
        viewcontroller.networkAPI = networkAPI

        _ = viewcontroller.requestAccountInfo(number: "1234567")

        XCTAssertEqual(viewcontroller.name, "Mary Zoo")
    }

    func testGetAccountNameExpectURLAndHeader() {

        let endpointClosure = { (target: NetworkAPI) -> Endpoint<NetworkAPI> in
            let endpoint: Endpoint<NetworkAPI> = Endpoint<NetworkAPI>(
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

        let e = expectation(description: "call plugin")

        let plugin = TestMoyaPlugin { result,status in
            expectedURL = result.request?.url?.absoluteString
            expectedAuthorizationHeader = result.request?.allHTTPHeaderFields?["Authorization"]

            XCTAssertEqual(expectedURL, "https://baseurl.com/accountinfo?accountNo=1234567")
            XCTAssertEqual(expectedAuthorizationHeader, "Sense")

            e.fulfill()
        }
        
        let viewcontroller = ViewController()
        let networkAPI = NetworkAPI(endpoint: "https://baseurl.com")

        networkAPI.provider = MoyaProvider<NetworkAPI>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.ImmediatelyStub, plugins:[plugin])

        viewcontroller.networkAPI = networkAPI

        _ = viewcontroller.requestAccountInfo(number: "1234567")

        waitForExpectations(timeout: 1) { _ in }
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

        public func willSendRequest(_ request: RequestType, target: TargetType) {
            networkActivityClosure(request,.began)
        }

        public func didReceiveResponse(_ result: Result<Moya.Response, Moya.Error>, target: TargetType) {}
    }
}
