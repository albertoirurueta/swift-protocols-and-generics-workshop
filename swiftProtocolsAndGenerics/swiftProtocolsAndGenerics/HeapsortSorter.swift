//
//  HeapsortSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Ordena arrays utilizando el algoritmo Heapsort.
 El algoritmo Heapsort se basa en la idea de árboles ordenados y tiene mejor
 rendimiento que la inserción directa.
 Esta clase se basa en el algoritmo descrito en:
 Numerical Recipes. 3rd Edition. Cambridge PRess. Chapter 8. p. 428.
 Knuth. D.E. 1997, Sorting and Searching, 3rd ed., vol. 3 of The Art of
 Computer Programming (Reading, MA: Addison-Wesley)
 Sedgewick, R. 1998. Algorithms in C, 3rd ed. (Reading, MA: Addison-Wesley),
 Chapter 11.
 */
public class HeapsortSorter : Sorter {
    
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
            return SortingMethod.heapsort
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
                              toIndex: Int,
                              comparator: (_ o1: T, _ o2: T) -> Int) throws {
        
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
        
        let n = toIndex - fromIndex
        
        //NOTA: stride through incluye el elemento final
        for i in stride(from: n / 2 - 1, through: 0, by: -1) {
            siftDown(&array, i, n - 1, comparator, fromIndex)
        }
        //NOTA: stride to no incluye el elemento final
        for i in stride(from: n - 1, to: 0, by: -1) {
            Sorter.swap(&array, posA: fromIndex, posB: i + fromIndex)
            siftDown(&array, 0, i - 1, comparator, fromIndex)
        }
    }
    
    /**
     Método interno para reordenar subarray ra
     */
    private func siftDown<T>(_ ra: inout [T], _ l: Int, _ r: Int,
                          _ comparator: (_ o1: T, _ o2: T) -> Int,
                          _ fromIndex: Int) {
        let a = ra[l + fromIndex]
        var jold = l
        var j = 2 * l + 1
        while j <= r {
            if j < r && comparator(ra[j + fromIndex], ra[j + 1 + fromIndex]) < 0 {
                j += 1
            }
            if comparator(a, ra[j + fromIndex]) >= 0 {
                break
            }
            ra[jold + fromIndex] = ra[j + fromIndex]
            jold = j
            j = 2 * j + 1
        }
        ra[jold + fromIndex] = a
    }
}
