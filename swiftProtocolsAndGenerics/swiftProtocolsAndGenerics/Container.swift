//
//  Container.swift
//  swiftProtocolsAndGenerics
//
//  Created by Alberto Irurueta Carro on 15/12/16.
//  Copyright © 2016 Alberto Irurueta Carro. All rights reserved.
//

import Foundation

/**
 Contenedor de un objeto cualquiera de tipo T.
 */
public class Container<T> {
    /**
     Valor interno almacenado por esta clase.
     */
    private var _value: T
    
    /**
     Constructor.
     - parameter value: valor inicial proporcionado.
     */
    public init(value: T) {
        _value = value
    }
    
    /**
     Obtiene o establece el valor interno de esta clase.
     */
    public var value: T {
        get{
            return _value
        }
        set {
            _value = newValue
        }
    }
}
