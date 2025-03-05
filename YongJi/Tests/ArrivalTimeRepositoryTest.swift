//
//  ArrivalTimeRepositoryTest.swift
//  YongJiBusTests
//
//  Created by 김도경 on 1/30/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import XCTest
@testable import YongJiBus

final class ArrivalTimeRepositoryTest: XCTestCase {

    private var repository : ArrivalTimeRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        repository.getArrivalTimes(busId: 1)
            .subscribe { dto in
                XCTAssertEqual(dto.count, 0)
            } onFailure: { error in
                print(error)
            }
            .dispose()

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
