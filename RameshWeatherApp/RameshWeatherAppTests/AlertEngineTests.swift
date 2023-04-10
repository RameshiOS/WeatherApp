//
//  AlertEngineTests.swift
//  RameshWeatherAppTests
//
//  Created by Ramesh Guddala on 08/04/23.
//

import XCTest
@testable import RameshWeatherApp

class AlertEngineTests: XCTestCase {

    func testCreateErrorAlertWithError() {
        // given
        let title = "Error"
        let error = NSError(domain: "test", code: 123, userInfo: nil)

        // when
        let alert = AlertEngine.createErrorAlert(title: title, error: error)

        // then
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.message, error.localizedDescription)
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(alert.actions.first?.title, "Ok")
        XCTAssertEqual(alert.actions.first?.style, .default)
    }

    func testCreateErrorAlertWithMessage() {
        // given
        let title = "Error"
        let message = "Something went wrong"

        // when
        let alert = AlertEngine.createErrorAlert(title: title, message: message)

        // then
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.message, message)
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(alert.actions.first?.title, "Ok")
        XCTAssertEqual(alert.actions.first?.style, .default)
    }

}
