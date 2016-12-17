//
//  Comparator.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 14/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Protocolo para permitir comparar objetos de tipo T.
 */
public protocol Comparator {
    
    /**
     Compara dos objetos de tipo T.
     - parameter o1: primer objeto a comparar.
     - parameter o2: segundo objeto a comparar.
     - returns: -1  si o1 es menor que o2, 0 si o1 y o2 son iguales o 1 si o1
     es mayor que o2.
     */
    func compare<T>(_ o1: T, _ o2: T) -> Int
}
