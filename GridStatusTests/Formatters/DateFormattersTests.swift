//
//  GridStatusTests.swift
//  GridStatusTests
//
//  Created by Nicolas Le Gorrec on 4/23/23.
//

@testable import GridStatus
import XCTest

final class DateFormattersTests: XCTestCase {
    func testISOToLocalDecode() throws {
        let utcDateString = "2023-04-23T17:25:00+00:00"
        let formatter = DateFormatters.utcStringToLocalDisplay()
        let localDateString = formatter(utcDateString)
        
        XCTAssert(localDateString == "Apr 23, 1:25 PM")
    }
}
