//
//  BBDD.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

class BBDD: NSObject {
    
    var facturas : Array<Factura>;
    
    override init ()
    {
        self.facturas = [];
        let letters : String;
        letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        for i in 0...10
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
            
            nuevaFactura.cIF?.append(randomString);
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
