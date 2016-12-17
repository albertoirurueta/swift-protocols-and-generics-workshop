//
//  ContainerTests.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import XCTest
@testable import swiftProtocolsAndGenerics

class ContainerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConstructorAndValue() {
        let value1 = "hello"
        
        let container1 = Container<String>(value: value1)
        
        //comprobamos valor inicial
        XCTAssertEqual(value1, container1.value)
        
        //establecemos nuevo valor
        container1.value = "bye"
        
        //comprobamos
        XCTAssertEqual(container1.value, "bye")
        
        
        
        let container2 = Container<Int>(value: 1)
        
        //valor inicial
        XCTAssertEqual(container2.value, 1)
        
        //nuevo valor
        container2.value = 10
        
        //comprobamos
        XCTAssertEqual(container2.value, 10)
    }        
}
