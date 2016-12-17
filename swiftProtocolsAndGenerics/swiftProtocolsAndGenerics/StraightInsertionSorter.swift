//
//  StraightInsertionSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Ordena arrays utilizando un algoritmo de inserción directa.
 El algoritmo de inserción directa es el más sencillo pero también el más lento,
 aunque puede ser útil en arrays pequeños.
 Esta clase se basa en el algoritmo descrito en:
 Numerical Recipes. 3rd Edition. Cambridge Press. Chapter B. p. 424
 Knuth. D.E. 1997, Sorting and Searching, 3rd ed., vol. 3 of The Art of Computer
 Programming (Reading, MA: Addison-Wesley).
 Sedgewich, R. 1998. Algorithms in C, 3rd ed. (Reading, MA: Addison-Wesley), 
 Chapter 11.
 */
public class StraightInsertionSorter : Sorter {
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
            return SortingMethod.straightInsertion
        }
    }
    
    /**
     Ordena el array proporcionado de forma ascendente de modo que:
     array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     - parameter array: array a ordenar. Tras la ejecución de este método los
     elementos entre la sposiciones fomIndex (incluído) y toIndex (excluído)
     se modifican de modo que quedan en orden ascendente.
     - parameter fromIndex: posición donde se inicia la ordenación (incluído).
     - parameter toIndex: posición donde finaliza la ordenación (excluído).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     - throws:
     - SorterError.illegalIndices si fromIndex es mayor que toIndex.
     - SorterError.indexOutOfBounds si los índices están fuera del rango
     de índices válido para el array proporcionado.
     */
    public override func sort<T>(_ array: inout [T], fromIndex: Int,
            toIndex: Int, comparator: (_ o1: T, _ o2: T) -> Int) throws {
        
        guard fromIndex <= toIndex else {
            throw SorterError.illegalIndices
        }
        guard fromIndex >= 0 && toIndex <= array.count else {
            throw SorterError.indexOutOfBounds
        }

        
        if fromIndex == toIndex {
            //no se ordena nada
            return;
        }
        
        for j in fromIndex + 1..<toIndex {
            //obtenemos cada elemento
            let a = array[j]
            
            var i = j
            
            //buscamos la posición donde debemos insertar el elemento a
            while i > fromIndex && comparator(array[i - 1], a) > 0 {
                array[i] = array[i - 1]
                i -= 1
            }
            
            //insertamos el valor
            array[i] = a
        }
    }
}
