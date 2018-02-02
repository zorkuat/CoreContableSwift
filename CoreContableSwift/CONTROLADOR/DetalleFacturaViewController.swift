//
//  DetalleFacturaViewController.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

class DetalleFacturaViewController: UIViewController {

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
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//////////////////////////////////////////////////////
//
//  OBJECTIVE C
//
//
//
//
/////////////////////////////////////////////////////



/*
// Método de recarga si hemos cancelado la edición de una factura. Muestra los datos anteriores.
// Método de carga. Se carga este después del didload.
-(void)viewWillAppear:(BOOL)animated
{
    self.facturaNumeroView.text = self.factura.numero;
    
    NSDateFormatter *formatoFecha = [[NSDateFormatter alloc] init];
    formatoFecha.dateFormat = @"dd / MM / yyyy";
    self.fechaExpedicionView.text = [formatoFecha stringFromDate:self.factura.fechaDeExpedicion];
    self.fechaOperacionLabel.text = [formatoFecha stringFromDate:self.factura.fechaDeOperacion];
    
    self.cIFView.text = self.factura.CIF;
    self.razonSocialView.text = self.factura.razonSocial;
    self.conceptoView.text = @"";
    //// BUCLE DE CONCEPTO
    for (int i=0; i< self.factura.conceptos.count; i++)
    {
        self.conceptoView.text = [self.conceptoView.text stringByAppendingString:self.factura.conceptos[i]];
        if (i != self.factura.conceptos.count-1){
            self.conceptoView.text = [self.conceptoView.text stringByAppendingString:@"\n"];
        }
    }
    self.baseView.text = [NSString stringWithFormat:@"%f", self.factura.baseImponible];
    self.IVAView.text = [NSString stringWithFormat:@"%ld%%", self.factura.tipoIVA];
    float total = (self.factura.baseImponible + self.factura.baseImponible*self.factura.tipoIVA/100) - self.factura.rectificacion;
    self.totalView.text = [NSString stringWithFormat:@"%f", total];
    self.rectificacionView.text = [NSString stringWithFormat:@"%ld", (long)self.factura.rectificacion];
    
    if (self.factura.imagenFactura != nil){
        self.imageView.image = self.factura.imagenFactura;
    }
    }
    
    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // PASO 1: Identificar el controlador de la transición. Sólo hay uno.
    if([segue.identifier isEqualToString:@"editarFactura"])
    {
        // Pasamos por el navegador primero.
        UINavigationController *controladorNavegacion = segue.destinationViewController;
        EditarFacturaController *escenaDestino = (id)controladorNavegacion.topViewController;
        
        // Vamos a pasar la información
        escenaDestino.factura = self.factura;
        escenaDestino.delegado = self;
        
    }
}

#pragma mark - Editar Contacto Delegate

-(void)cancelar
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)guardarfactura:(Factura *)factura
{
    // [self.bbdd.facturas addObject:self.factura];
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
*/
