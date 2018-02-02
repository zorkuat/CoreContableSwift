//
//  factura.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit
import Foundation


class Factura: NSObject {
    
    ///////////////////////////////////////
    //// VARIABLES OBLIGADAS DE FACTURA ///
    ///////////////////////////////////////
    
    /// Número de factura
    /// a) Número y, en su caso, serie.
    var numero : String = "";
    
    /// b) Fecha de expedición.
    var fechaDeExpedicion : Date?;

    /// c) Fecha de operación si es distinta de la de expedición.
    var fechaDeOperacion : Date?;
    
    /// d) NIF y nombre y apellidos, razón o denominación social del expedidor.
    var cIF : String?;
    
    // $$$$ Ya veré si lo hago con expecializaciones de clase
    //@property (nonatomic) NSString *nombre;
    //@property (nonatomic) NSString *apellidos;
    
    /// e) Nombre del contacto al que se le hace la factura. Extenderá a clase.
    var razonSocial : String?;
    
    /// e) Identificación de los bienes entregados o servicios prestados.
    var conceptos : Array<String>?;
    
    /// f) Tipo impositivo, y opcionalmente también la expresión “IVA incluido”
    var tipoIva : Int?;
    
    /// g) Contraprestación total.
    var baseImponible : Float?;
    
    /// h) En las facturas rectificativas, la referencia a la factura rectificada.
    var rectificacion : Float?;
    
    
    /*
    /// i) En su caso, si se producen las siguientes circunstancias:
    /// - En operaciones exentas referencia a la normativa
    /// - La mención “facturación por el destinatario”
    /// - La mención “inversión del sujeto pasivo”
    /// - La mención “Régimen especial de Agencias de viajes”
    /// - La mención “Régimen especial de bienes usados”.
    @property (nonatomic) BOOL estaExenta;
    @property (nonatomic) NSString *normaExencion;
    @property (nonatomic) BOOL facturacionDestinatario;
    @property (nonatomic) BOOL inversionPasivo;
    @property (nonatomic) BOOL regimenEspecialAgenciaViajes;
    @property (nonatomic) BOOL regimenEspecialBienesUsados;
    
    /////////////////////////////////////////////
    //// VARIABLES DE PERSISTENCIA Y RESPALDO ///
    /////////////////////////////////////////////
    @property (nonatomic) UIImage *imagenFactura;
    @property (nonatomic) NSFileManager *ficheroFactura;
    
    @end*/


}


