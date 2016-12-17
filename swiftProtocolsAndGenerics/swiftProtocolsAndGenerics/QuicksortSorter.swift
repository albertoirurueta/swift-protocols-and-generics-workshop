//
//  QuicksortSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Ordena arrays utilizando el algoritmo Quicksort.
 El algoritmo quicksort es el más complejo pero el que ordena arrays de 
 cualquier tamaño en el menor tiempo en promedio.
 Esta clase se basa en el algoritmo descrito en:
 Numerical Recipes. 3rd Edition. Cambridge Press. Chapter 8. p. 424
 Sedgewich, R. 1978. "Implementing Quicksort Programs", Communications of the
 ACM, vol. 21. pp. 847-857.
 */
public class QuicksortSorter : Sorter {
    
    /**
     Constante que define el tamaño de los subarrays más pequeños ordenados 
     utilizando inserción directa.
     */
    private static let M = 7
    
    /**
     Constante que define el tamaño de pila.
     */
    private static let NStack = 64
    
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
            return SortingMethod.quicksort
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
        
        var a = array[fromIndex]
        let n = toIndex - fromIndex
        var istack = [Int](repeating: 0, count: QuicksortSorter.NStack)
        var ir = n - 1
        var l = 0
        var jstack = -1
        
        repeat {
            //ordenación por inserción cuando el array es lo suficientemente
            //pequeño
            if (ir - l) < QuicksortSorter.M {
                var j = l + 1
                while j <= ir {
                    a = array[j + fromIndex]
                    var i = j - 1
                    while i >= l {
                        if comparator(array[i + fromIndex], a) <= 0 {
                            break
                        }
                        array[i + 1 + fromIndex] = array[i + fromIndex]
                        i -= 1
                    }
                    array[i + 1 + fromIndex] = a
                    j += 1
                }
                
                //el while anterior con el for en orden inverso es equivalente a lo siguiente:
                /*if (l + 1) <= ir {
                    for j in (l + 1)...ir {
                        let a = array[j + fromIndex]
                        var i = 0
                        if (j - 1) >= l {
                            for i2 in stride(from: j - 1, through: l, by: -1) {
                                i = i2
                                //NOTA: también puede usarse in (l ... j - 1).reversed()
                                if comparator(array[i + fromIndex], a) <= 0 {
                                    break
                                }
                                array[i + 1 + fromIndex] = array[i + fromIndex]
                            }
                        }
                        array[i + 1 + fromIndex] = a
                    }
                }*/
                
                if jstack < 0 {
                    break
                }
                //pop stack y empezamos una nueva ronda de partición
                ir = istack[jstack]
                jstack -= 1
                l = istack[jstack]
                jstack -= 1
            } else {
                //escogemos mediana del elemento de la izquierda, centra y 
                //derecha como elementos de partición, y a la vez reordenamos
                //de modo que a[l] <= a[l + 1] <= a[ir]
                let k = (l + ir) >> 1
                Sorter.swap(&array, posA: k + fromIndex,
                            posB: l + 1 + fromIndex)
                
                if comparator(array[l + fromIndex], array[ir + fromIndex]) > 0 {
                    Sorter.swap(&array, posA: l + fromIndex,
                                posB: ir + fromIndex)
                }
                
                if comparator(array[l + 1 + fromIndex], array[ir + fromIndex]) > 0 {
                    Sorter.swap(&array, posA: l + 1 + fromIndex,
                                posB: ir + fromIndex)
                }
                
                if comparator(array[l + fromIndex], array[l + 1 + fromIndex]) > 0 {
                    Sorter.swap(&array, posA: l + fromIndex,
                                posB: l + 1 + fromIndex)
                }
                
                //inicializamos punteros para la partición
                var i = l + 1
                var j = ir
                //elemento de partición
                a = array[l + 1 + fromIndex]
                //Inicio del loop más interno
                repeat {
                    //buscamos elemento > a
                    repeat {
                        i += 1
                    } while comparator(array[i + fromIndex], a) < 0
                    //buscamos elemento < a
                    repeat {
                        j -= 1
                    } while comparator(array[j + fromIndex], a) > 0
                    
                    //si los punteros se cruzan, la partición se ha completado
                    if j < i {
                        break;
                    }
                    
                    //intercambiamos elementos
                    Sorter.swap(&array, posA: i + fromIndex,
                                posB: j + fromIndex)
                    
                    //fin del loop más interno
                } while true
                
                array[l + 1 + fromIndex] = array[j + fromIndex]
                array[j + fromIndex] = a
                jstack += 2
                
                //NStack demasiado pequeño para ordenar
                if jstack >= QuicksortSorter.NStack {
                    throw Sorter.SorterError.sortingError
                }
                
                //movemos los punteros a un subarray más grande en el stack
                //y procesamos el subarray más pequeño inmediatamente
                if (ir - i + 1) >= (j - l) {
                    istack[jstack] = ir
                    istack[jstack - 1] = i
                    ir = j - 1
                } else {
                    istack[jstack] = j - 1
                    istack[jstack - 1] = l
                    l = i
                }
            }
        } while true
    }
}
