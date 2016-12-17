//
//  ShellSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Ordena arrays utilizando el algoritmo de Shell.
 El algoritmo de Shell es una mejora del algoritmo de inserción directa para
 ordenar arrays de forma más rápida.
 Esta clase se basa en el algoritmo descrito en:
 Numerical Recipes. 3rd Edition. Cambridge Press. Chapter 8. p. 422
 Knuth. D.E. 1997, Sorting and Searching, 3rd ed., vol. 3 of The Art of
 Computer Programming (Reading, MA: Addison-Wesley)
 Sedgewich, R. 1998. Algorithms in C, 3rd ed. (Reading, MA: Addison-Wesley),
 Chapter 11.
 */
public class ShellSorter: Sorter {
    
    /**
     Constante que define el factor de incremento a utilizar de forma interna.
     */
    private static let IncrementFactor = 3
    
    /**
     Constante que define el incremento mínimo antes de detener el proceso de
     ordenación.
     */
    private static let MinIncrement = 1
    
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
            return SortingMethod.shell
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
        
        
        if(fromIndex == toIndex) {
            //no se ordena nada
            return;
        }
        
        var inc = ShellSorter.MinIncrement
        let n = toIndex - fromIndex
        
        repeat {
            inc *= ShellSorter.IncrementFactor
            inc += 1
        } while inc <= n
        
        //iteramos sobre las ordenaciones parciales
        repeat {
            inc /= ShellSorter.IncrementFactor
            //bucle exterior de inserción directa
            for i in inc..<n {
                let v = array[i + fromIndex]
                var j = i
                
                //bucle interno de inserción directa
                while comparator(array[j - inc + fromIndex], v) > 0 {
                    array[j + fromIndex] = array[j - inc + fromIndex]
                    j -= inc
                    if j < inc {
                        break
                    }
                }
                array[j + fromIndex] = v
            }
        } while inc > ShellSorter.MinIncrement
    }
    
}
