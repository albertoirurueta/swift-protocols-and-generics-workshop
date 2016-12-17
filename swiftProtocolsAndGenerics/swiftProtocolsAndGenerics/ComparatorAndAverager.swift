//
//  ComparatorAndAverager.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Permite comparar objetos y obtener el promedio entre dos objetos de tipo T.
 Este protocolo se utiliza para obtener la mediana en array de longitud par.
 */
public protocol ComparatorAndAverager : Comparator {
    /**
     Calcula el promedio de los dos valores proporcionados.
     - parameter o1: primer valor.
     - parameter o2: segundo valor.
     - returns: promedio de los dos valores proporcionados.
     */
    func average<T>(_ o1: T, _ o2: T) -> T
}
