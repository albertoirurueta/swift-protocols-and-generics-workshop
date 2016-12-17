//
//  BaseSorter.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 14/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Clase base para ordenar arrays de tipo T en orden ascendente (de menor a 
 mayor).
 Si se desea obtener el orden inverso, se pueden utilizar closures o Comparators
 para invertir el orden.
 Esta clase no puede instanciarse directamente, debe usarse una de las subclases
 disponibles.
 */
public class Sorter {
    
    /**
     Método de ordenación utilizado por defecto.
     */
    public static let DefaultSortingMethod = SortingMethod.quicksort
    
    /**
     Constructor.
     Es privado para impedir la instanciación directa de esta clase.
     */
    internal init() { }
    
    /**
     Devuelve el método utilizado para ordenar.
     Esta propiedad debe sobreescribirse en las correspondientes subclases.
     */
    public var method: SortingMethod {
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
    public func sort<T>(_ array: inout [T], fromIndex: Int, toIndex: Int,
              comparator: (_ o1: T, _ o2: T) -> Int) throws {
        //debe implementarse en subclases
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
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public func sort<T>(_ array: inout [T], fromIndex from: Int,
                     toIndex to: Int, comparator: Comparator) throws {
        try sort(&array, fromIndex: from, toIndex: to,
             comparator: { (o1, o2) -> Int in
                return comparator.compare(o1, o2)
        })
    }
    
    /**
     Ordena el array de Comparables proporcionado de forma ascendente de modo 
     que: array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     - parameter array: array a ordenar. Tras la ejecución de este método los
     elementos entre la sposiciones fomIndex (incluído) y toIndex (excluído)
     se modifican de modo que quedan en orden ascendente.
     - parameter fromIndex: posición donde se inicia la ordenación (incluído).
     - parameter toIndex: posición donde finaliza la ordenación (excluído).
     */
    public func sort<T : Comparable>(_ array: inout [T], fromIndex from: Int,
                     toIndex to: Int) throws {
        try sort(&array, fromIndex: from, toIndex: to,
             comparator: { (o1, o2) -> Int in
                return Sorter.compare(o1, o2)
        })
    }
    
    /**
     Ordena el array proporcionado de forma ascendente de modo que:
     array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     - parameter array: array a ordenar.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     */
    public func sort<T>(_ array: inout [T],
                     comparator c: (_ o1: T, _ o2: T) -> Int) {
        do {
            try sort(&array, fromIndex: 0, toIndex: array.count, comparator: c)
        } catch { }
    }
    
    /**
     Ordena el array proporcionado de forma ascendente de modo que:
     array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     - parameter array: array a ordenar.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     */
    public func sort<T>(_ array: inout [T], comparator c: Comparator) {
        do {
            try sort(&array, fromIndex: 0, toIndex: array.count, comparator: c)
        } catch { }
    }
    
    /**
     Ordena el array de Comparables proporcionado de forma ascendente de modo 
     que: array[i - 1] < array[i] para cualquier i válido.
     Este método modifica el array proporcionado de modo que tras la ejecución
     los elementos del array quedan ordenados.
     - parameter array: array a ordenar.
     */
    public func sort<T : Comparable>(_ array: inout [T]) {
        do {
            try sort(&array, fromIndex: 0, toIndex: array.count)
        } catch { }
    }
    
    /**
     Ordena el array proporcionado de forma ascendente y devuelve un nuevo array
     con el resultado.
     - parameter array: array a ordenar.
     - parameter fromIndex: posición donde se inicia la ordenación (incluído).
     - parameter toIndex: posición donde finaliza la ordenación (excluído).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     - returns: nuevo array con las posiciones entre fromIndex (incluído) y
     toIndex (excluído) ordenadas en orden ascendente.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public func sorted<T>(_ array: [T],
                                 fromIndex from: Int,
                                 toIndex to: Int,
                                 comparator c: (_: T, _: T) -> Int)
        throws -> [T] {
            
        //copia array de entrada
        var result = [T](array)
        //ordena
        try sort(&result, fromIndex: from, toIndex: to, comparator: c)
        
        return result
    }
    
    /**
     Ordena el array proporcionado de forma ascendente y devuelve un nuevo array
     con el resultado.
     - parameter array: array a ordenar.
     - parameter fromIndex: posición donde se inicia la ordenación (incluído).
     - parameter toIndex: posición donde finaliza la ordenación (excluído).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     - returns: nuevo array con las posiciones entre fromIndex (incluído) y
     toIndex (excluído) ordenadas en orden ascendente.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public func sorted<T>(_ array: [T], fromIndex from: Int, toIndex to: Int,
                       comparator: Comparator) throws -> [T] {
        return try sorted(array, fromIndex: from, toIndex: to,
                                comparator: { (o1, o2) -> Int in
                                    return comparator.compare(o1, o2)
        })
    }
    
    /**
     Ordena el array de Comparables proporcionado de forma ascendente y devuelve 
     un nuevo array con el resultado.
     - parameter array: array a ordenar.
     - parameter fromIndex: posición donde se inicia la ordenación (incluído).
     - parameter toIndex: posición donde finaliza la ordenación (excluído).
     - returns: nuevo array con las posiciones entre fromIndex (incluído) y
     toIndex (excluído) ordenadas en orden ascendente.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public func sorted<T : Comparable>(_ array: [T], fromIndex from: Int,
                       toIndex to: Int) throws -> [T] {
            
        return try sorted(array, fromIndex: from, toIndex: to,
                                comparator: { (o1, o2) -> Int in
                                    return Sorter.compare(o1, o2)
        })
    }
    
    /**
     Ordena el array proporcionado de forma ascendente y devuelve un nuevo array
     con el resultado.
     - parameter array: array a ordenar.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     - returns: nuevo array ordenado.
     */
    public func sorted<T>(_ array: [T],
                       comparator c: (_ o1: T, _ o2: T) -> Int) -> [T] {

        return try! sorted(array, fromIndex: 0, toIndex: array.count,
                           comparator: c)
    }
    
    /**
     Ordena el array proporcionado de forma ascendente y devuelve un nuevo array
     con el resultado.
     - parameter array: array a ordenar.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     - returns: nuevo array ordenado.
     */
    public func sorted<T>(_ array: [T], comparator c: Comparator) -> [T] {
        
            return try! sorted(array, fromIndex: 0,
                                         toIndex: array.count, comparator: c)
    }
    
    /**
     Ordena el array de Comparables proporcionado de forma ascendente y devuelve 
     un nuevo array con el resultado.
     - parameter array: array a ordenar.
     - returns: nuevo array ordenado.
     */
    public func sorted<T : Comparable>(_ array: [T]) -> [T] {
        return try! sorted(array, fromIndex: 0, toIndex: array.count)
    }

    /**
     Devuelve el elemento ordenado en la posición pos del array proporcionado,
     iniciando la ordenación en fromIndex hasta toIndex. Los elementos del array 
     fuera de este rango se ignoran.
     La selección de un elemento normalmente es más rápido que ordenar todo el 
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por 
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo 
     que en la posición k-esima se almacena el elemento ordenado k-esimo, entre
     las posiciónes array[fromIndex] ... array[k -1 + fromIndex] se almacenan
     los elementos sin ordenar menores que cualquiera de los elementos ordenados
     y en las posiciones array[k + 1 + fromIndex] ... array[toIndex - 1] se
     almacenan los elementos sin ordenar mayores que cualquiera de los elementos
     ordenados.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución 
     de este método.
     - parameter fromIndex: posición donde se inicia la ordenación (inclusivo).
     - parameter toIndex: posición donde finaliza la ordenación (exclusivo).
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
    public static func select<T>(_ pos: Int, from array: inout [T],
                       fromIndex: Int, toIndex: Int,
                       comparator: (_ o1: T, _ o2: T) -> Int) throws -> T {
        guard fromIndex <= toIndex else {
            throw SorterError.illegalIndices
        }
        guard fromIndex >= 0 && toIndex <= array.count else {
            throw SorterError.indexOutOfBounds
        }
        
        let n = toIndex - fromIndex
        
        guard pos < n else {
            throw SorterError.illegalIndices
        }
        
        var l = 0
        var ir = n - 1
        repeat {
            if ir <= l + 1 {
                if ir == l + 1 &&
                    comparator(array[ir + fromIndex], array[l + fromIndex]) < 0 {
                    swap(&array, posA: l + fromIndex, posB: ir + fromIndex)
                }
                return array[pos + fromIndex]
            } else {
                let mid = (l + ir) >> 1
                swap(&array, posA: mid + fromIndex, posB: l + 1 + fromIndex)
                if comparator(array[l + fromIndex], array[ir + fromIndex]) > 0 {
                    swap(&array, posA: l + fromIndex, posB: ir + fromIndex)
                }
                if comparator(array[l + 1 + fromIndex], array[ir + fromIndex]) > 0 {
                    swap(&array, posA: l + 1 + fromIndex, posB: ir + fromIndex)
                }
                if comparator(array[l + fromIndex], array[l + 1 + fromIndex]) > 0 {
                    swap(&array, posA: l + fromIndex, posB: l + 1 + fromIndex)
                }
                var i = l + 1
                var j = ir
                let a = array[l + 1 + fromIndex]
                repeat {
                    repeat {
                        i += 1
                    } while comparator(array[i + fromIndex], a) < 0
                    repeat {
                        j -= 1
                    } while comparator(array[j + fromIndex], a) > 0
                    if j < i {
                        break
                    }
                    swap(&array, posA: i + fromIndex, posB: j + fromIndex)
                } while true
                array[l + 1 + fromIndex] = array[j + fromIndex]
                array[j + fromIndex] = a
                if j >= pos {
                    ir = j - 1
                }
                if j <= pos {
                    l = i
                }                
            }
        } while true
    }
    
    /**
     Devuelve el elemento ordenado en la posición pos del array proporcionado,
     iniciando la ordenación en fromIndex hasta toIndex. Los elementos del array
     fuera de este rango se ignoran.
     La selección de un elemento normalmente es más rápido que ordenar todo el
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo
     que en la posición k-esima se almacena el elemento ordenado k-esimo, entre
     las posiciónes array[fromIndex] ... array[k -1 + fromIndex] se almacenan
     los elementos sin ordenar menores que cualquiera de los elementos ordenados
     y en las posiciones array[k + 1 + fromIndex] ... array[toIndex - 1] se
     almacenan los elementos sin ordenar mayores que cualquiera de los elementos
     ordenados.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución
     de este método.
     - parameter fromIndex: posición donde se inicia la ordenación (inclusivo).
     - parameter toIndex: posición donde finaliza la ordenación (exclusivo).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public static func select<T>(_ pos: Int, from array: inout [T],
                       fromIndex from: Int, toIndex to: Int,
                       comparator: Comparator) throws -> T {
        return try select(pos, from: &array, fromIndex: from, toIndex: to,
                     comparator: { (o1, o2) -> Int in
                        return comparator.compare(o1, o2)
        })
    }

    /**
     Devuelve el elemento Comparable ordenador en la posición pos del array 
     proporcionado, iniciando la ordenación en fromIndex hasta toIndex. Los 
     elementos del array fuera de este rango se ignoran.
     La selección de un elemento normalmente es más rápido que ordenar todo el
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo
     que en la posición k-esima se almacena el elemento ordenado k-esimo, entre
     las posiciónes array[fromIndex] ... array[k -1 + fromIndex] se almacenan
     los elementos sin ordenar menores que cualquiera de los elementos ordenados
     y en las posiciones array[k + 1 + fromIndex] ... array[toIndex - 1] se
     almacenan los elementos sin ordenar mayores que cualquiera de los elementos
     ordenados.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución
     de este método.
     - parameter fromIndex: posición donde se inicia la ordenación (inclusivo).
     - parameter toIndex: posición donde finaliza la ordenación (exclusivo).
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public static func select<T : Comparable>(_ pos: Int, from array: inout [T],
                       fromIndex from: Int, toIndex to: Int) throws -> T {
        return try select(pos, from: &array, fromIndex: from, toIndex: to,
                      comparator: { (o1, o2) -> Int in
                        return compare(o1, o2)
        })
    }
    
    /**
     Devuelve el elemento ordenado en la posición pos del array proporcionado.
     La selección de un elemento normalmente es más rápido que ordenar todo el
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo
     que en la posición k-ésima se almacena el elemento ordenado k-esimo.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución
     de este método.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     */
    public static func select<T>(_ pos: Int, from array: inout [T],
                       comparator c: (_: T, _: T) -> Int) -> T {
        
        return try! select(pos, from: &array, fromIndex: 0,
                           toIndex: array.count, comparator: c)
    }
    
    /**
     Devuelve el elemento ordenado en la posición pos del array proporcionado.
     La selección de un elemento normalmente es más rápido que ordenar todo el
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo
     que en la posición k-ésima se almacena el elemento ordenado k-esimo.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución
     de este método.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     */
    public static func select<T>(_ pos: Int, from array: inout [T],
                       comparator c: Comparator) -> T {
        return try! select(pos, from: &array, fromIndex: 0,
                              toIndex: array.count, comparator: c)
    }
    
    /**
     Devuelve el elemento Comparable ordenado en la posición pos del array 
     proporcionado.
     La selección de un elemento normalmente es más rápido que ordenar todo el
     array por completo (sobretodo en arrays grandes), y por ese motivo debería
     usarse en lugar de sort si no es necesario ordenar todo el array por
     completo.
     Puesto que el array se pasa por referencia como un parámetro inout, tras
     la ejecución de este método el array proporcionado se modifica de tal modo
     que en la posición k-ésima se almacena el elemento ordenado k-esimo.
     - parameter pos: posición del elemento ordenado a obtener.
     - parameter array: array a utilizar para obtener el elemento ordenado. El
     array proporcionado se pasa por referencia y se modifica tras la ejecución
     de este método.
     */
    public static func select<T : Comparable>(_ pos: Int, from array: inout [T])
        -> T {

        return try! select(pos, from: &array, fromIndex: 0,
                              toIndex: array.count)
    }
    
    /**
     Calcula la mediana del array proporcionado.
     La mediana se define como el valor central del rango de posiciones del 
     array considerando que los elementos del array están ordenados.
     El valor central a obtener del array es el ubicado en la posición 
     (toIndex - fromIndex) / 2
     Este método modifica el array proporcionado de modo que tras la ejecución
     contiene el elemento ordenado en la posición (toIndex - fromIndex) / 2,
     elementos menores sin ordenar en array[fromIndex] ... array[(toIndex - fromIndex) / 2 + fromIndex - 1]
     y elementos mayores sin ordenar en array[(toIndex - fromIndex) / 2 + fromIndex - 1 ... array[toIndex - 1]
     - parameter: array a utilizar para obtener su mediana. El array 
     proporcionado se pasa por referencia y se modifica tras la ejecución de
     este método.
     - parameter fromIndex: posición donde se inicia la ordenación (inclusivo).
     - parameter toIndex: posición donde finaliza la ordenación (exclusivo).
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     - parameter averager: obtiene el promedio entre los valores o1 y o2 
     proporcionados.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public static func median<T>(_ array: inout [T], fromIndex from: Int,
                       toIndex to: Int, comparator c: (_ o1: T, _ o2: T) -> Int,
                       averager: (_ o1: T, _ o2: T) -> T) throws -> T {
        guard from <= to else {
            throw SorterError.illegalIndices
        }
        guard from >= 0 && to <= array.count else {
            throw SorterError.indexOutOfBounds
        }

        let length = to - from
        
        let pos1 = length / 2
        let value1 = try select(pos1, from: &array, fromIndex: from,
                                toIndex: to, comparator: c)
        
        //seleccionamos el elemento ordenado en la pos pos1 (posición central y
        //modificamos el array de modo que:
        //array[0] ... array[pos1 - 1] < value1 < array[pos1 + 1] ... array[length - 1]
        //donde array[0] ... array[pos1 - 1] son elementos sin ordenar menores que value1
        //y array[pos1] ... array[length - 1] son elementos sin ordenar mayores que value1
        if length % 2 == 0 {
            //longitud par
            
            //value2 es el elemento ordenado previo del array, el cual es el
            //máximo entre array[0] ... array[pos1 - 1]
            var value2 = array[from]
            for i in 1..<pos1 {
                let value3 = array[i + from]
                if c(value3, value2) > 0 {
                    value2 = value3
                }
            }
            
            return averager(value1, value2)
        } else {
            //longitud impar
            return value1
        }
    }
    
    /**
     Calcula la mediana del array proporcionado.
     La mediana se define como el valor central del rango de posiciones del
     array considerando que los elementos del array están ordenados.
     El valor central a obtener del array es el ubicado en la posición
     (toIndex - fromIndex) / 2
     Este método modifica el array proporcionado de modo que tras la ejecución
     contiene el elemento ordenado en la posición (toIndex - fromIndex) / 2,
     elementos menores sin ordenar en array[fromIndex] ... array[(toIndex - fromIndex) / 2 + fromIndex - 1]
     y elementos mayores sin ordenar en array[(toIndex - fromIndex) / 2 + fromIndex - 1 ... array[toIndex - 1]
     - parameter: array a utilizar para obtener su mediana. El array
     proporcionado se pasa por referencia y se modifica tras la ejecución de
     este método.
     - parameter fromIndex: posición donde se inicia la ordenación (inclusivo).
     - parameter toIndex: posición donde finaliza la ordenación (exclusivo).
     - parameter comparatorAndAverager: determina si un elemento es mayor o 
     menor que otro y calcula el promedio entre dos elementos.
     - throws:
        - SorterError.illegalIndices si fromIndex es mayor que toIndex.
        - SorterError.indexOutOfBounds si los índices están fuera del rango
        de índices válido para el array proporcionado.
     */
    public static func median<T>(_ array: inout [T], fromIndex from: Int,
                       toIndex to: Int,
                       comparatorAndAverager ca: ComparatorAndAverager)
        throws -> T {
            
        return try median(&array, fromIndex: from, toIndex: to,
                      comparator: { (o1, o2) -> Int in
                        return ca.compare(o1, o2)
        }, averager: { (o1, o2) -> T in
            return ca.average(o1, o2)
        })
    }
    
    /**
     Calcula la mediana del array proporcionado.
     La mediana se define como el valor central del rango de posiciones del
     array considerando que los elementos del array están ordenados.
     - parameter: array a utilizar para obtener su mediana. El array
     proporcionado se pasa por referencia y se modifica tras la ejecución de
     este método.
     - parameter comparator: determina si un elemento es mayor o menor que otro.
     Devuelve -1 si o1 es menor que o2, 0 si o1 es igual a o2 y 1 si o1 es mayor
     que o2.
     - parameter o1: primer elemento a comparar
     - parameter o2: segundo elemento a comparar
     - parameter averager: obtiene el promedio entre los valores o1 y o2
     proporcionados.
     */
    public static func median<T>(_ array: inout [T], comparator c: (_: T, _: T)
        -> Int,
                       averager a: (_: T, _: T) -> T) -> T {
        return try! median(&array, fromIndex: 0, toIndex: array.count,
                           comparator: c, averager: a)
    }
    
    /**
     Calcula la mediana del array proporcionado.
     La mediana se define como el valor central del rango de posiciones del
     array considerando que los elementos del array están ordenados.
     - parameter: array a utilizar para obtener su mediana. El array
     proporcionado se pasa por referencia y se modifica tras la ejecución de
     este método.
     - parameter comparatorAndAverager: determina si un elemento es mayor o
     menor que otro y calcula el promedio entre dos elementos.
     */
    public static func median<T>(_ array: inout [T],
                       comparatorAndAverager ca: ComparatorAndAverager) -> T {
        return try! median(&array, fromIndex: 0, toIndex: array.count,
                      comparatorAndAverager: ca)
    }
    
    /**
     Método de factoría para crear instancias de Sorter que utilicen el método
     de ordenación indicado.
     - param method: método de ordenación.
     */
    public static func create(method: SortingMethod) -> Sorter {
        switch method {
        case .foundation:
            return FoundationSorter()
        case .heapsort:
            return HeapsortSorter()
        case .quicksort:
            return QuicksortSorter()
        case .shell:
            return ShellSorter()
        case .straightInsertion:
            return StraightInsertionSorter()
        }
    }
    
    /**
     Método de factoría para crear instancias de Sorter con el método de 
     ordenación por defecto.
     */
    public static func create() -> Sorter {
        return create(method: DefaultSortingMethod)
    }
    
    /**
     Intercambio los valores del array proporcionado en las posiciones indicadas
     - param array: array que contiene los valores a intercambiar.
     */
    internal static func swap<T>(_ array: inout [T], posA: Int, posB: Int) {
        let value = array[posA]
        array[posA] = array[posB]
        array[posB] = value
    }
    
    /**
     Compara dos instancias Comparables.
     - parameter o1: primer Comparable a comparar.
     - parameter o2: segundo Comparable a comparar.
     - returns: -1 si o1 es menor que o2, 0 si 01 y 02 son iguales o 1 si o1 es
     mayor que o2.
     */
    private static func compare<T : Comparable>(_ o1: T, _ o2: T) -> Int {
        if o1 < o2 {
            return -1
        } else if o1 == o2 {
            return 0
        } else {
            return 1
        }
    }
    
    /**
     Tipos de error que pueden obtenerse al ordenar arrays.
     */
    public enum SorterError : Error {
        /**
         Si la posición fromIndex es mayor que la posición toIndex
         */
        case illegalIndices
        
        /**
         Si se proporcionan valores de índices fuera del rango de índices 
         accesibles por el array proporcionado (entre 0 y su count - 1).
         */
        case indexOutOfBounds
        
        /**
         Si la ordenación falla por cualquier otro motivo.
         */
        case sortingError
    }
}
