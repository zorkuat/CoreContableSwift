//
//  EditarFacturaDelegate.swift
//  CoreContableSwift
//
//  Created by Tomás Álvarez on 3/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

protocol EditarFacturaDelegate : class {

    func guardarFactura(_ factura : Factura);
    func cancelar();
}
