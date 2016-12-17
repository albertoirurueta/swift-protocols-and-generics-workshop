//
//  SorterTests.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import XCTest
@testable import swiftProtocolsAndGenerics

class SorterTests: XCTestCase {
    
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
    
    func testSortWithRangeAndComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = StraightInsertionSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    StraightInsertionSorterTests.maxLength -
                        StraightInsertionSorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
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
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
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
    
    func testSortWithRangeAndComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = StraightInsertionSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    StraightInsertionSorterTests.maxLength -
                        StraightInsertionSorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            
            //ordenamos en orden ascendente
            let ascComparator = ComparatorAscendant<Int>()
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex,
                             comparator: ascComparator)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //ordenamos en orden descendente
            let descComparator = ComparatorDescendant<Int>()
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex,
                             comparator: descComparator)
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertGreaterThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
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
                             comparator: ascComparator)
            
            //comprobamos que array y array2 siguen siendo iguales porque array
            //no ha cambiado
            XCTAssertEqual(array, array2)
            
            
            //Throw SorterError.illegalIndices
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: toIndex,
                    toIndex: fromIndex, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.illegalIndices)
            }
            
            //Throw SorterError.indexOutOfBounds
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: -1,
                    toIndex: toIndex, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            XCTAssertThrowsError(try sorter.sort(&array, fromIndex: fromIndex,
                    toIndex: length + 1, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
        }
    }
    
    func testSortWithRangeComparable() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    SorterTests.maxLength - SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
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
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: fromIndex)
            
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
    
    func testSortWithComparatorClosure() {
        for _ in 1...StraightInsertionSorterTests.times {
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
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            sorter.sort(&array, comparator: { (o1, o2) -> Int in
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
            
            //ordenamos en orden descendente
            sorter.sort(&array, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return 1
                } else if o1 == o2 {
                    return 0
                } else {
                    return -1
                }
            })
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array[0]
            for i in 1..<length {
                XCTAssertGreaterThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
        }
    }

    func testSortWithComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    SorterTests.maxLength - SorterTests.minLength)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            let ascComparator = ComparatorAscendant<Int>()
            sorter.sort(&array, comparator: ascComparator)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
            
            //ordenamos en orden descendente
            let descComparator = ComparatorDescendant<Int>()
            sorter.sort(&array, comparator: descComparator)
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array[0]
            for i in 1..<length {
                XCTAssertGreaterThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
        }
    }

    func testSortComparable() {
        for _ in 1...SorterTests.times {
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
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            sorter.sort(&array)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array[i])
                prevValue = array[i]
            }
        }
    }
    
    func testSortedWithRangeAndComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = StraightInsertionSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    StraightInsertionSorterTests.maxLength -
                        StraightInsertionSorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            var array2 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: toIndex, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            })
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //ordenamos en orden descendente
            array2 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: toIndex, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return 1
                } else if o1 == o2 {
                    return 0
                } else {
                    return -1
                }
            })
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array2[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertGreaterThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            //realizamos una copia (instancias distintas con mismo contenido)
            array2 = array
            
            //comprobamos que son instancias distintas
            let ptr1 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr1.initialize(to: array)
            let ptr2 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr2.initialize(to: array2)
            XCTAssertFalse(ptr1.distance(to: ptr2) == 0)
            
            //pero con mismo contenido
            XCTAssertEqual(array, array2)
            
            //ordenamos con indices iguales
            let array3 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: fromIndex, comparator: { (o1, o2) -> Int in
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
            XCTAssertEqual(array, array3)
            
            
            //Throw SorterError.illegalIndices
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: toIndex,
                    toIndex: fromIndex, comparator: { (o1, o2) -> Int in
                return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.illegalIndices)
            }
            
            //Throw SorterError.indexOutOfBounds
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: -1,
                    toIndex: toIndex, comparator: { (o1, o2) -> Int in
                return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: length + 1, comparator: { (o1, o2) -> Int in
                return 0 })
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
        }
    }
    
    func testSortedWithRangeAndComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = StraightInsertionSorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    StraightInsertionSorterTests.maxLength -
                        StraightInsertionSorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            
            //ordenamos en orden ascendente
            let ascComparator = ComparatorAscendant<Int>()
            var array2 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: toIndex, comparator: ascComparator)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //ordenamos en orden descendente
            let descComparator = ComparatorDescendant<Int>()
            array2 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: toIndex, comparator: descComparator)
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array2[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertGreaterThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = StraightInsertionSorterTests.minValue +
                    Int(arc4random()) % (StraightInsertionSorterTests.maxValue -
                        StraightInsertionSorterTests.minValue)
            }
            
            //realizamos una copia (instancias distintas con mismo contenido)
            array2 = array
            
            //comprobamos que son instancias distintas
            let ptr1 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr1.initialize(to: array)
            let ptr2 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr2.initialize(to: array2)
            XCTAssertFalse(ptr1.distance(to: ptr2) == 0)
            
            //pero con mismo contenido
            XCTAssertEqual(array, array2)
            
            //ordenamos con indices iguales
            let array3 = try! sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: fromIndex, comparator: ascComparator)
            
            //comprobamos que array y array2 siguen siendo iguales porque array
            //no ha cambiado
            XCTAssertEqual(array, array2)
            XCTAssertEqual(array, array3)
            
            
            //Throw SorterError.illegalIndices
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: toIndex,
                    toIndex: fromIndex, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.illegalIndices)
            }
            
            //Throw SorterError.indexOutOfBounds
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: -1,
                    toIndex: toIndex, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: fromIndex,
                    toIndex: length + 1, comparator: ascComparator)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
        }
    }
    
    func testSortedWithRangeComparable() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    SorterTests.maxLength - SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            var array2 = try! sorter.sorted(array, fromIndex: fromIndex,
                                            toIndex: toIndex)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[fromIndex]
            for i in (fromIndex + 1)..<toIndex {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //comprobamos que si fromIndex y toIndex son iguales, el array no
            //se modifica. Para ello volvemos a poner valores aleatorios
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            //realizamos una copia (instancias distintas con mismo contenido)
            array2 = array
            
            //comprobamos que son instancias distintas
            let ptr1 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr1.initialize(to: array)
            let ptr2 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr2.initialize(to: array2)
            XCTAssertFalse(ptr1.distance(to: ptr2) == 0)
            
            //pero con mismo contenido
            XCTAssertEqual(array, array2)
            
            //ordenamos con indices iguales
            let array3 = try! sorter.sorted(array, fromIndex: fromIndex,
                                          toIndex: fromIndex)
            
            //comprobamos que array y array2 siguen siendo iguales porque array
            //no ha cambiado
            XCTAssertEqual(array, array2)
            XCTAssertEqual(array, array3)
            
            
            //Throw SorterError.illegalIndices
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: toIndex,
                        toIndex: fromIndex)) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.illegalIndices)
            }
            
            //Throw SorterError.indexOutOfBounds
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: -1,
                        toIndex: toIndex)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            XCTAssertThrowsError(try sorter.sorted(array, fromIndex: fromIndex,
                        toIndex: length + 1)
            ) { error in
                XCTAssertEqual(error as? Sorter.SorterError,
                               Sorter.SorterError.indexOutOfBounds)
            }
            
        }
    }
    
    func testSortedWithComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    SorterTests.maxLength - SorterTests.minLength)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            var array2 = sorter.sorted(array, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            })
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //ordenamos en orden descendente
            array2 = sorter.sorted(array, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return 1
                } else if o1 == o2 {
                    return 0
                } else {
                    return -1
                }
            })
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array2[0]
            for i in 1..<length {
                XCTAssertGreaterThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
        }
    }
    
    func testSortedWithComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(
                    SorterTests.maxLength - SorterTests.minLength)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue +
                    Int(arc4random()) % (SorterTests.maxValue -
                        SorterTests.minValue)
            }
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            let ascComparator = ComparatorAscendant<Int>()
            var array2 = sorter.sorted(array, comparator: ascComparator)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
            
            //ordenamos en orden descendente
            let descComparator = ComparatorDescendant<Int>()
            array2 = sorter.sorted(array, comparator: descComparator)
            
            //comprobamos que se ha ordenado en orden descendente
            prevValue = array2[0]
            for i in 1..<length {
                XCTAssertGreaterThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
        }
    }
    
    func testSortedComparable() {
        for _ in 1...SorterTests.times {
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
            
            let sorter = Sorter.create()
            
            //ordenamos en orden ascendente
            let array2 = sorter.sorted(array)
            
            //comprobamos que se ha ordenado en orden ascendente
            var prevValue = array2[0]
            for i in 1..<length {
                XCTAssertLessThanOrEqual(prevValue, array2[i])
                prevValue = array2[i]
            }
        }
    }
    
    func testSelectWithRangeAndComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            let pos = Int(arc4random_uniform(UInt32(toIndex - fromIndex)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            //copiamos array
            var array2 = array
            
            //ordenamos array de forma ascendente entre fromIndex y toIndex
            //NOTA: array.sort() no nos sirve en este caso
            let sorter = Sorter.create()
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            let selected = try! Sorter.select(pos, from: &array2,
                    fromIndex: fromIndex, toIndex: toIndex,
                    comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            })
            XCTAssertEqual(selected, array[pos + fromIndex])
            
            //comprobamos que los elementos en array2[fromIndex] ... array2[pos + fromIndex - 1]
            //son menores que el valor seleccionado
            for i in fromIndex..<(pos + fromIndex) {
                XCTAssertTrue(array2[i] <= selected)
            }
            
            //comprobamos que los elementos en array2[pos + 1 + fromIndex] ... array2[toIndex - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1 + fromIndex)..<toIndex {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }

    func testSelectWithRangeAndComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            let pos = Int(arc4random_uniform(UInt32(toIndex - fromIndex)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            //copiamos array
            var array2 = array
            
            //ordenamos array de forma ascendente entre fromIndex y toIndex
            //NOTA: array.sort() no nos sirve en este caso
            let sorter = Sorter.create()
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            let ascComparator = ComparatorAscendant<Int>()
            let selected = try! Sorter.select(pos, from: &array2,
                    fromIndex: fromIndex, toIndex: toIndex,
                    comparator: ascComparator)
            XCTAssertEqual(selected, array[pos + fromIndex])
            
            //comprobamos que los elementos en array2[fromIndex] ... array2[pos + fromIndex - 1]
            //son menores que el valor seleccionado
            for i in fromIndex..<(pos + fromIndex) {
                XCTAssertTrue(array2[i] <= selected)
            }
            
            //comprobamos que los elementos en array2[pos + 1 + fromIndex] ... array2[toIndex - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1 + fromIndex)..<toIndex {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }
    
    func testSelectWithRangeComparable() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            let pos = Int(arc4random_uniform(UInt32(toIndex - fromIndex)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            //copiamos array
            var array2 = array
            
            //ordenamos array de forma ascendente entre fromIndex y toIndex
            //NOTA: array.sort() no nos sirve en este caso
            let sorter = Sorter.create()
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            let selected = try! Sorter.select(pos, from: &array2,
                                              fromIndex: fromIndex,
                                              toIndex: toIndex)
            XCTAssertEqual(selected, array[pos + fromIndex])
            
            //comprobamos que los elementos en array2[fromIndex] ... array2[pos + fromIndex - 1]
            //son menores que el valor seleccionado
            for i in fromIndex..<(pos + fromIndex) {
                XCTAssertTrue(array2[i] <= selected)
            }
            
            //comprobamos que los elementos en array2[pos + 1 + fromIndex] ... array2[toIndex - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1 + fromIndex)..<toIndex {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }
    
    func testSelectWithComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let pos =  Int(arc4random_uniform(UInt32(length)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            //copiamos array
            var array2 = array
            
            //ordenamos array de forma ascendente entre fromIndex y toIndex
            //NOTA: array.sort() no nos sirve en este caso
            let sorter = Sorter.create()
            sorter.sort(&array)
            
            let selected = Sorter.select(pos, from: &array2,
                    comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            })
            XCTAssertEqual(selected, array[pos])
            
            //comprobamos que los elementos en array2[0] ... array2[pos - 1]
            //son menores que el valor seleccionado
            for i in 0..<(pos) {
                XCTAssertTrue(array2[i] <= selected)
            }
            
            //comprobamos que los elementos en array2[pos + 1] ... array2[length - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1)..<length {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }

    func testSelectWithComparatorProtocol() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let pos =  Int(arc4random_uniform(UInt32(length)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            //copiamos array
            var array2 = array
            
            //ordenamos array de forma ascendente entre fromIndex y toIndex
            //NOTA: array.sort() no nos sirve en este caso
            let sorter = Sorter.create()
            sorter.sort(&array)
            
            let ascComparator = ComparatorAscendant<Int>()
            let selected = Sorter.select(pos, from: &array2,
                comparator: ascComparator)
            XCTAssertEqual(selected, array[pos])
            
            //comprobamos que los elementos en array2[0] ... array2[pos - 1]
            //son menores que el valor seleccionado
            for i in 0..<(pos) {
                XCTAssertTrue(array2[i] <= selected)
            }
            
            //comprobamos que los elementos en array2[pos + 1] ... array2[length - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1)..<length {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }
    
    func testSelectComparable() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let pos =  Int(arc4random_uniform(UInt32(length)))
        
            var array = [Int](repeating: 0, count: length)
        
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
        
            //copiamos array
            var array2 = array
        
            //comprobamos que son instancias distintas
            let ptr1 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr1.initialize(to: array)
            let ptr2 = UnsafeMutablePointer<[Int]>.allocate(capacity: 1)
            ptr2.initialize(to: array2)
            XCTAssertFalse(ptr1.distance(to: ptr2) == 0)

            //pero con mismo contenido
            XCTAssertEqual(array, array2)
        
        
            //ordenamos array de forma ascendente
            array.sort()
        
            //comprobamos que se ha ordenado de forma ascendente
            for i in 0..<length {
                if i > 0 {
                    XCTAssertTrue(array[i - 1] <= array[i])
                }
            }
        
            //seleccionamos en pos
            let selected = Sorter.select(pos, from: &array2)
            XCTAssertEqual(selected, array[pos])
        
            //comprobamos que los elementos en array2[0] ... array2[pos - 1] son
            //menores que el valor seleccionado
            for i in 0..<pos {
                XCTAssertTrue(array2[i] <= selected)
            }
        
            //comprobamos que los elementos en array2[pos + 1] ... array2[length - 1]
            //son mayores que el valor seleccionado
            for i in (pos + 1)..<length {
                XCTAssertTrue(array2[i] >= selected)
            }
        }
    }
    
    func testMedianWithRangeAndComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            let n = toIndex - fromIndex
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            var array2 = array
            
            let sorter = Sorter.create()
            
            //ordenamos array original
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            //después del cálculo de mediana, array2 contenerá elementos menores
            //que array[length/2 + fromIndex) y elementos mayores que
            //array[length/2 + fromIndex] porque la selección se realiza en
            //length/2 + fromIndex
            let median = try! Sorter.median(&array2, fromIndex: fromIndex,
                    toIndex: toIndex, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            }, averager: { (o1, o2) -> Int in
                return (o1 + o2) / 2
            })
            
            XCTAssertEqual(array[n/2 + fromIndex], array2[n/2 + fromIndex])
            
            for i in fromIndex..<(n/2 + fromIndex) {
                XCTAssertLessThanOrEqual(array2[i], array[n/2 + fromIndex])
            }
            
            for i in (n/2 + fromIndex)..<toIndex {
                XCTAssertGreaterThanOrEqual(array2[i], array[n/2 + fromIndex])
            }
            
            //comprobamos valor de mediana
            var otherMedian = 0
            if n % 2 == 0 {
                //longitud par
                otherMedian = (array[(n / 2 + fromIndex) - 1] +
                    array[n / 2 + fromIndex]) / 2
            } else {
                otherMedian = array[n / 2 + fromIndex]
            }
            
            XCTAssertEqual(otherMedian, median)
        }
    }

    func testMedianWithRangeAndComparatorAndAverager() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            let fromIndex = Int(arc4random_uniform(UInt32(length - 2)))
            let toIndex = fromIndex + 1 + Int(arc4random_uniform(UInt32(
                length - fromIndex - 1)))
            let n = toIndex - fromIndex
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            var array2 = array
            
            let sorter = Sorter.create()
            
            //ordenamos array original
            try! sorter.sort(&array, fromIndex: fromIndex, toIndex: toIndex)
            
            //después del cálculo de mediana, array2 contenerá elementos menores
            //que array[length/2 + fromIndex) y elementos mayores que
            //array[length/2 + fromIndex] porque la selección se realiza en
            //length/2 + fromIndex
            let comparatorAverager = IntComparatorAndAveragerAscendant()
            let median = try! Sorter.median(&array2, fromIndex: fromIndex,
                toIndex: toIndex, comparatorAndAverager: comparatorAverager)
            
            XCTAssertEqual(array[n/2 + fromIndex], array2[n/2 + fromIndex])
            
            for i in fromIndex..<(n/2 + fromIndex) {
                XCTAssertLessThanOrEqual(array2[i], array[n/2 + fromIndex])
            }
            
            for i in (n/2 + fromIndex)..<toIndex {
                XCTAssertGreaterThanOrEqual(array2[i], array[n/2 + fromIndex])
            }
            
            //comprobamos valor de mediana
            var otherMedian = 0
            if n % 2 == 0 {
                //longitud par
                otherMedian = (array[(n / 2 + fromIndex) - 1] +
                    array[n / 2 + fromIndex]) / 2
            } else {
                otherMedian = array[n / 2 + fromIndex]
            }
            
            XCTAssertEqual(otherMedian, median)
        }
    }

    func testMedianWithComparatorClosure() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            var array2 = array
            
            let sorter = Sorter.create()
            
            //ordenamos array original
            sorter.sort(&array)
            
            //después del cálculo de mediana, array2 contenerá elementos menores
            //que array[length/2 + fromIndex) y elementos mayores que
            //array[length/2 + fromIndex] porque la selección se realiza en
            //length/2 + fromIndex
            let median = Sorter.median(&array2, comparator: { (o1, o2) -> Int in
                if o1 < o2 {
                    return -1
                } else if o1 == o2 {
                    return 0
                } else {
                    return 1
                }
            }, averager: { (o1, o2) -> Int in
                return (o1 + o2) / 2
            })
            
            XCTAssertEqual(array[length/2], array2[length/2])
            
            for i in 0..<(length/2) {
                XCTAssertLessThanOrEqual(array2[i], array[length/2])
            }
            
            for i in (length/2)..<length {
                XCTAssertGreaterThanOrEqual(array2[i], array[length/2])
            }
            
            //comprobamos valor de mediana
            var otherMedian = 0
            if length % 2 == 0 {
                //longitud par
                otherMedian = (array[(length / 2) - 1] +
                    array[length / 2]) / 2
            } else {
                otherMedian = array[length / 2]
            }
            
            XCTAssertEqual(otherMedian, median)
        }
    }
    
    func testMedianWithComparatorAndAverager() {
        for _ in 1...SorterTests.times {
            let length = SorterTests.minLength +
                Int(arc4random_uniform(UInt32(SorterTests.maxLength -
                    SorterTests.minLength)))
            
            var array = [Int](repeating: 0, count: length)
            
            for i in 0..<length {
                array[i] = SorterTests.minValue + Int(arc4random()) %
                    (SorterTests.maxValue - SorterTests.minValue)
            }
            
            var array2 = array
            
            let sorter = Sorter.create()
            
            //ordenamos array original
            sorter.sort(&array)
            
            //después del cálculo de mediana, array2 contenerá elementos menores
            //que array[length/2 + fromIndex) y elementos mayores que
            //array[length/2 + fromIndex] porque la selección se realiza en
            //length/2 + fromIndex
            let comparatorAverager = IntComparatorAndAveragerAscendant()
            let median = Sorter.median(&array2,
                    comparatorAndAverager: comparatorAverager)
            
            XCTAssertEqual(array[length/2], array2[length/2])
            
            for i in 0..<(length/2) {
                XCTAssertLessThanOrEqual(array2[i], array[length/2])
            }
            
            for i in (length/2)..<length {
                XCTAssertGreaterThanOrEqual(array2[i], array[length/2])
            }
            
            //comprobamos valor de mediana
            var otherMedian = 0
            if length % 2 == 0 {
                //longitud par
                otherMedian = (array[(length / 2) - 1] +
                    array[length / 2]) / 2
            } else {
                otherMedian = array[length / 2]
            }
            
            XCTAssertEqual(otherMedian, median)
        }
    }

    func testCreate() {
        var sorter = Sorter.create()
        
        XCTAssertEqual(sorter.method, SortingMethod.quicksort)
        XCTAssertTrue(sorter is QuicksortSorter)
        
        sorter = Sorter.create(method: SortingMethod.foundation)
        
        XCTAssertEqual(sorter.method, SortingMethod.foundation)
        XCTAssertTrue(sorter is FoundationSorter)
        
        sorter = Sorter.create(method: SortingMethod.heapsort)
        
        XCTAssertEqual(sorter.method, SortingMethod.heapsort)
        XCTAssertTrue(sorter is HeapsortSorter)
        
        sorter = Sorter.create(method: SortingMethod.quicksort)
        
        XCTAssertEqual(sorter.method, SortingMethod.quicksort)
        XCTAssertTrue(sorter is QuicksortSorter)
        
        sorter = Sorter.create(method: SortingMethod.shell)
        
        XCTAssertEqual(sorter.method, SortingMethod.shell)
        XCTAssertTrue(sorter is ShellSorter)
        
        sorter = Sorter.create(method: SortingMethod.straightInsertion)
        
        XCTAssertEqual(sorter.method, SortingMethod.straightInsertion)
        XCTAssertTrue(sorter is StraightInsertionSorter)
    }
    
    class IntComparatorAscendant : ComparatorAscendant<Int> { }
    
    class IntCompaaratorDescendant : ComparatorDescendant<Int> { }
    
    class IntComparatorAndAveragerAscendant :
        ComparatorAndAveragerAscendant<Int> { }
}

class ComparatorAscendant<U : Comparable> :
        swiftProtocolsAndGenerics.Comparator {
    
    public func compare<T>(_ o1: T, _ o2: T) -> Int {
        if let c1 = o1 as? U, let c2 = o2 as? U {
            if c1 < c2 {
                return -1
            } else if c1 == c2 {
                return 0
            } else {
                return 1
            }
        } else {
            return -1
        }
    }
}

class ComparatorDescendant<U : Comparable> :
        swiftProtocolsAndGenerics.Comparator {
    
    public func compare<T>(_ o1: T, _ o2: T) -> Int {
        if let c1 = o1 as? U, let c2 = o2 as? U {
            if c1 < c2 {
                return 1
            } else if c1 == c2 {
                return 0
            } else {
                return -1
            }
        } else {
            return -1
        }
    }
}

class ComparatorAndAveragerAscendant<U : Comparable> :
    swiftProtocolsAndGenerics.ComparatorAndAverager {
    
    public func compare<T>(_ o1: T, _ o2: T) -> Int {
        if let c1 = o1 as? U, let c2 = o2 as? U {
            if c1 < c2 {
                return -1
            } else if c1 == c2 {
                return 0
            } else {
                return 1
            }
        } else {
            return -1
        }
    }

    public func average<T>(_ o1: T, _ o2: T) -> T {
        if let i1 = o1 as? Int, let i2 = o2 as? Int {
            return ((i1 + i2) / 2) as! T
        } else {
            return 0 as! T
        }
    }
}


