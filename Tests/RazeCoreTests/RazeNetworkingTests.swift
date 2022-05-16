//
//  RazeNetworkingTests.swift
//  RazeCoreTests
//
//  Created by Gene Bogdanovich on 16.05.22.
//

import XCTest
@testable import RazeCore

class NetworkSessionMock: NetworkingSession {
    var data: Data?
    var error: Error?
    func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
    
    
}

final class RazeNetworkingTests: XCTestCase {
    func testLoadDataCall() {
        let manager = RazeCore.Networking.Manager()
        
        let session = NetworkSessionMock()
        manager.session = session
        
        let expectation = XCTestExpectation(description: "Called for data.")
        let data = Data([0,1,0,1])
        session.data = data
        let url = URL(fileURLWithPath: "url")
        
        manager.loadData(from: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let returnedData):
                XCTAssertEqual(data, returnedData, "manager returned unexpected data")
            case .failure(let error):
                XCTFail(error?.localizedDescription ?? "error forming error result")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
