//
//  BBDD.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

/**
 
 # CLASE BASE DE DADOS
 
 Clase de trabajo (funcionamiento en caliente) de almacenamiento de las facturas.
 Incluye un constructor de generación de facturas de prueba para el testeo durante el desarrollo.
 */
class BBDD: NSObject {
    
    /// Array principal de almacenamiento de facturas
    var facturas : Array<Factura>;
    
/**
     # OVERRIDE INIT
     
     Inicializador de la base de datos. Se crea una base de datos dummie con 10 facturas con datos aleatorios no vacíos.
     
     ## Variables internas de trabajo:
     * facturas: array de facturas.
 */
    override init ()
    {
        /// init de facturas
        self.facturas = [];
        let letters : String;
        letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        for i in 0..<10
        {
            let nuevaFactura : Factura = Factura();
         
            var randomString : String = "";
            
            for _ in 0...2
            {
                let ix = letters.startIndex;
                let ix2 = letters.index(ix, offsetBy: Int(arc4random_uniform(UInt32(letters.count))))
                randomString.append(letters[ix2])
            }
            
            nuevaFactura.numero = randomString + "\(arc4random_uniform(1000))";
            nuevaFactura.fechaDeExpedicion = Date(timeIntervalSince1970: Double(arc4random_uniform(48)*365*54*60*60));
            nuevaFactura.fechaDeOperacion = Date(timeIntervalSince1970: Double(arc4random_uniform(48)*365*54*60*60));
            nuevaFactura.baseImponible = Float(arc4random_uniform(2000));
            
            randomString = "";
            for _ in 0..<1
            {
                let ix = letters.startIndex;
                let ix2 = letters.index(ix, offsetBy: Int(arc4random_uniform(UInt32(letters.count))))
                randomString.append(letters[ix2])
            }
            
            nuevaFactura.cIF.append(randomString);
            nuevaFactura.cIF.append("\(arc4random_uniform(1000000000))")
            nuevaFactura.razonSocial = "Razon Social \(i+1)";
            
            nuevaFactura.conceptos = [];
            for j in 0...4
            {
                let concepto = "Concepto \(j+1)";
                nuevaFactura.conceptos?.append(concepto);
            }
            
            nuevaFactura.tipoIva = 21;
            nuevaFactura.baseImponible = Float(arc4random_uniform(2000));
            nuevaFactura.rectificacion = 0;
            
            self.facturas.append(nuevaFactura);
        }
    }
}
