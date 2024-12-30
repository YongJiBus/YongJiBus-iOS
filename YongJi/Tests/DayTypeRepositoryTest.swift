//
//  DayTypeRepositoryTest.swift
//  YongJiBusTests
//
//  Created by 김도경 on 11/17/24.
//  Copyright © 2024 yongjibus.org. All rights reserved.
//

import XCTest
@testable import YongJiBus

final class DayTypeRepositoryTest: XCTestCase {
    
    private var repository : DayTypeRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = DayTypeRepository()
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
        
        repository.getDayType()
            .subscribe { result in
                XCTAssertEqual(false, result)
            } onFailure: { error in
                print("error \(error)")
            }.dispose()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
