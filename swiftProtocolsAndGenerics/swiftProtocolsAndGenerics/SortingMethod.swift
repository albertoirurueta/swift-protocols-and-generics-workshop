//
//  SortingMethod.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Define distintos algoritmos para ordenar arrays de datos.
 */
public enum SortingMethod {
    /**
     Algoritmo de inserción directa. 
     Es un algoritmo sencillo y lento para ordenar, aunque para arrays pequeños 
     puede ser suficientemente rápido.
     */
    case straightInsertion
    
    /**
     Algoritmo de Shell. 
     Este algoritmo es una mejora sobre el de inserción directa para ordenar de
     forma más rápida.
     */
    case shell
    
    /**
     Algoritmo Quicksort.
     Este es el algoritmo más rápido en promedio para ordenar arrays de 
     cualquier tamaño.
     */
    case quicksort
    
    /**
     Algoritmo heapsort.
     Este algoritmo se basa en la idea de árboles ordenados y obtiene resultados
     de forma más rápida que la inserción directa.
     */
    case heapsort
    
    /**
     Utiliza el algoritmo proporcionado por el foundation de swift para ordenar.
    */
    case foundation
}
