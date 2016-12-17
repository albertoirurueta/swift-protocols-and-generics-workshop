//
//  ShellSorterTests.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 16/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import XCTest
@testable import swiftProtocolsAndGenerics

class ShellSorterTests: XCTestCase {

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
        let sorter = ShellSorter()
        XCTAssertEqual(sorter.method, SortingMethod.shell)
    }
    
    func testSortWithRange() {
        for _ in 1...ShellSorterTests.times {
            let length = ShellSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    ShellSorterTests.maxLength -
                        ShellSorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = ShellSorterTests.minValue +
                    Int(arc4random()) % (ShellSorterTests.maxValue -
                        ShellSorterTests.minValue)
            }
            
            let sorter = ShellSorter()
            
            //ordenamos en orden ascendente
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex,
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
            var prevValue = array[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //ordenamos en orden descendente
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex,
                    comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return 1
                } else if o1 == o2 {
                    return 0
                } else {
                    return -1
                }
            })
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertGreaterThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = ShellSorterTests.minValue +
                    Int(arc4random()) % (ShellSorterTests.maxValue -
                        ShellSorterTests.minValue)
            }
            
            //realizamos una copia (instancias distintas con mismo contenido)
            let array2 = array
            
            //comprobamos que son instancias distintas
            let ptr1 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr1.initialize(to: array)
            let ptr2 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr2.initialize(to: array2)
            XCTAssertFalse(ptr1.distance(to: ptr2) == 0)
            
            //pero con mismo contenido
            XCTAssertEqual(array, array2)
            
            //ordenamos con indices iguales
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: fromIndex,
                    comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            })
            
            //comprobamos que array y array2 siguen siendo iguales porque array
            //no ha cambiado
            XCTAssertEqual(array, array2)
            
            
            //Throw SorterError.illegalIndices
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: toIndex,
                toIndex: fromIndex, comparator: { (o1, o2) -> Int in
                    return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.illegalIndices)
            }
            
            //Throw SorterError.indexOutOfBounds
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: -1,
                toIndex: toIndex, comparator: { (o1, o2) -> Int in
                    return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: fromIndex,
                toIndex: length + 1, comparator: { (o1, o2) -> Int in
                    return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }            
        }
    }
}
