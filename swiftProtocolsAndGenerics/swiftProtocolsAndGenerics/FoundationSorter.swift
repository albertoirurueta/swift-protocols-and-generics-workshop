//
//  FoundationSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Ordena array utilizando el algoritmo proporcionado por la Foundation de Swift.
 */
public class FoundationSorter : Sorter {
    /**
     Constructor.
     */
    public override init() {
        super.init()
    }
    
    /**
     Devuelve el método utilizado para ordenar.
     Esta propiedad debe sobreescribirse en las correspondientes subclases.
     */
    public override var method: SortingMethod {
        get{
            return SortingMethod.foundation
        }
    }
    
    /**
     Ordena el array proporcionado de forma ascendente de modo que:
     array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     Esta implementación ordena todo el array de forma completa, por lo
     que los parámetros fromIndex y toIndex se ignoran.
     - parameter array: array a ordenar. Tras la ejecución de este método los
     elementos entre la sposiciones fomIndex (incluído) y toIndex (excluído)
     se modifican de modo que quedan en orden ascendente.
     - parameter fromIndex: posición donde se inicia la ordenación (se ignora).
     - parameter toIndex: posición donde finaliza la ordenación (se ignora).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     */
    public override func sort<T>(_ array: inout [T], fromIndex: Int,
                              toIndex: Int,
                              comparator: (_ o1: T, _ o2: T) -> Int) {
        
        array.sort { (o1, o2) -> Bool in
            FoundationSorter.compare(o1, o2, Int.self)
        }
    }
    
    /**
     Hack para comparar dos objetos cualesquiera sólo si son comparables.
     - returns: true si o1 es mayor que o2, false en caso contrario o si los
     objetos no son Comparables.
     */
    private static func compare<T: Comparable>(_ o1: Any, _ o2: Any,
                                _ type: T.Type) -> Bool{
        if let c1 = o1 as? T, let c2 = o2 as? T {
            return c1 < c2
        } else {
            return false
        }
    }
}
