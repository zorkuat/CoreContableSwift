//
//  EditarFacturaDelegate.swift
//  CoreContableSwift
//
//  Created by Tomás Álvarez on 3/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

/**
 # Protocolo de Editar Factura
 
 Interfaz entre clases para garantizar la guarda o cancelación de los datos entre vistas.
 
*/
protocol EditarFacturaDelegate : class {

    /// Método para guardar el objeto de trabajo. Se intercambia el objeto factura.
    func guardarFactura(_ factura : Factura);
    
    /// Método de cancelación. Se debe garantizar la salvaguarda de los datos.
    func cancelar();
}
