//
//  Helper.swift
//  
//
//  Created by Yang Xu on 2023/9/5.
//

import Foundation
import XCTest

extension XCTestCase {
    func measureAsync(
        timeout: TimeInterval = 2.0,
        for block: @escaping () async throws -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        measureMetrics(
            [.wallClockTime],
            automaticallyStartMeasuring: true
        ) {
            let expectation = expectation(description: "finished")
            Task {
                do {
                    try await block()
                    expectation.fulfill()
                } catch {
                    XCTFail(error.localizedDescription, file: file, line: line)
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: timeout)
        }
    }
}
