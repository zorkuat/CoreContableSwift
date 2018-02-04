//
//  DetalleFacturaViewController.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

class DetalleFacturaViewController: UIViewController, EditarFacturaDelegate {

    var factura : Factura = Factura();
    
    @IBOutlet weak var facturaNumeroView: UILabel!
    @IBOutlet weak var fechaExpedicionView: UILabel!
    @IBOutlet weak var fechaOperacionView: UILabel!
    @IBOutlet weak var cIFView: UILabel!
    @IBOutlet weak var razonSocialView: UILabel!
    @IBOutlet weak var conceptoView: UILabel!
    @IBOutlet weak var baseView: UILabel!
    @IBOutlet weak var tipoIVAView: UILabel!
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var rectificacionView: UILabel!

    
    // PRE: self.factura != nil
    // POST: UILabels[].text == self.factura.contenido
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.facturaNumeroView.text = factura.numero;
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        self.fechaExpedicionView.text = formatoFecha.string(from: self.factura.fechaDeExpedicion!);
        self.fechaOperacionView.text = formatoFecha.string(from: self.factura.fechaDeOperacion!);
        self.cIFView.text = self.factura.cIF;
        self.razonSocialView.text = self.factura.razonSocial;
        
        self.conceptoView.text = "";
        for i in 0 ..< self.factura.conceptos!.count
        {
            self.conceptoView.text!.append(self.factura.conceptos![i]);
            self.conceptoView.text!.append("\n");
        }
        self.baseView.text = "\(self.factura.baseImponible!)"
        self.tipoIVAView.text = "\(self.factura.tipoIva!)"
        let total = self.factura.baseImponible! + self.factura.baseImponible!*Float(self.factura.tipoIva!)/100.0 - self.factura.rectificacion!;
        self.totalView.text = "\(total)"
        self.tipoIVAView.text = "\(self.factura.tipoIva!)";
        self.rectificacionView.text = "\(self.factura.rectificacion!)";
    }
    
    // Método de recarga si hemos cancelado la edición de una factura. Muestra los datos anteriores.
    // Método de carga. Se carga este después del didload.
    override func viewWillAppear(_ animated: Bool) {
        self.facturaNumeroView.text = factura.numero;
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        self.fechaExpedicionView.text = formatoFecha.string(from: self.factura.fechaDeExpedicion!);
        self.fechaOperacionView.text = formatoFecha.string(from: self.factura.fechaDeOperacion!);
        self.cIFView.text = self.factura.cIF;
        self.razonSocialView.text = self.factura.razonSocial;
        
        self.conceptoView.text = "";
        for i in 0 ..< self.factura.conceptos!.count
        {
            self.conceptoView.text!.append(self.factura.conceptos![i]);
            self.conceptoView.text!.append("\n");
        }
        self.baseView.text = "\(self.factura.baseImponible!)"
        self.tipoIVAView.text = "\(self.factura.tipoIva!)"
        let total = self.factura.baseImponible! + self.factura.baseImponible!*Float(self.factura.tipoIva!)/100.0 - self.factura.rectificacion!;
        self.totalView.text = "\(total)";
        self.tipoIVAView.text = "\(self.factura.tipoIva!)";
        self.rectificacionView.text = "\(self.factura.rectificacion!)";
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // PASO 1: Identificar el controlador de la transición. Sólo hay uno.
        if segue.identifier == "editarFactura"
        {
            // Pasamos por el navegador primero.
            let navController = segue.destination as! UINavigationController;
            let escenaDestino = navController.topViewController as! EditarFacturaTableViewController;
            
            // Vamos a pasar la información
            escenaDestino.factura = self.factura;
            escenaDestino.delegado = self;
        }
    }
    
    // MARK: - Editar Contacto Delegate
    
    func guardarFactura(_ factura: Factura) {
        self.factura = factura;
        //self.bbdd.facturas.append(factura);
        self.dismiss(animated: true, completion: nil);
    }
    
    func cancelar() {
        self.dismiss(animated: true, completion: nil);
    }

}
