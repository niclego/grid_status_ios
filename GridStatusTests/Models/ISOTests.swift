//
//  GridStatusTests.swift
//  GridStatusTests
//
//  Created by Nicolas Le Gorrec on 4/23/23.
//

@testable import GridStatus
import XCTest

final class ISOTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testISODecode() throws {
        if let path = Bundle.main.path(forResource: "isos_latest_query_response", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let isoResponse = try JSONDecoder().decode(ISOLatestResonse.self, from: data)
                XCTAssert(!isoResponse.data.isEmpty)
            } catch {
                throw error
            }
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
