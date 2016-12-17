//
//  FoundationSorterTests.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 17/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import XCTest
@testable import swiftProtocolsAndGenerics

class FoundationSorterTests: XCTestCase {
    
    static let minLength = 10
    static let maxLength = 100
    
    static let minValue = 0
    static let maxValue = 100
    
    static let times = 50
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSortingMethod() {
        let sorter = FoundationSorter()
        XCTAssertEqual(sorter.method, SortingMethod.foundation)
        
    }
    
    func testSort() {
        for _ in 1...FoundationSorterTests.times {
            let length = StraightInsertionSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    StraightInsertionSorterTests.maxLength -
                        StraightInsertionSorterTests.minLength)))

            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }

            let sorter = FoundationSorter()
            
            //ordenamos en orden ascendente
            sorter.sort(&array, fromIndex: 0, toIndex: length,
                             comparator: { (o1, o2) -> Int in
                                if o1 < o2 {
                                    return -1
                                } else if o1 == o2 {
                                    return 0
                                } else {
                                    return 1
                                }
            })
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
        }
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
