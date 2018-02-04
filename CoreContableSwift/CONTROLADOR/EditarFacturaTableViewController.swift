//
//  EditarFacturaTableViewController.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

class EditarFacturaTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var fechaExpedicionTextField: UITextField!
    @IBOutlet weak var fechaOperacionTextField: UITextField!
    @IBOutlet weak var cIFTextField: UITextField!
    @IBOutlet weak var razonSocialTextField: UITextField!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var tipoIVATextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var rectificacionTextField: UITextField!
    @IBOutlet weak var ficheroTextField: UITextField!
    
    @IBOutlet var pickerFecha: UIDatePicker!
    @IBOutlet var barraEditor: UIToolbar!
    
    var listaConceptos : Array<UITextField> = [];
    var campoTextoActual : UITextField?;
    var campoTextoNuevo : UITextField?;
 
    var factura : Factura = Factura();
    var copiaConceptos : Array<String> = [];
 
    weak var delegado : EditarFacturaDelegate?;
    
    ////////////////////////////////////
    // MÉTODO DE CARGA DE LAS VISTAS. //
    ///////////////////////////////////////////////////////////////////////////////////////
    // Creamos la variable de trabajo local y actualizamos los campos si no son vacíos.  //
    // Asociamos las referencias a vista con los campos de la variable de trabajo local. //
    ///////////////////////////////////////////////////////////////////////////////////////
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        tableView.register(ConceptoCell.self, forCellReuseIdentifier: "ConceptoCell");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Inicialización del objeto de trabajo conceptos que servirá para salvaguardar en caso de cancelación
        self.copiaConceptos = self.factura.conceptos!;

        // Enlace de los pickers para fecha y botón accesorio adjunto
        self.pickerFecha.translatesAutoresizingMaskIntoConstraints = false;
        self.fechaExpedicionTextField.inputView = self.pickerFecha;
        self.fechaExpedicionTextField.inputAccessoryView = self.barraEditor;
        self.fechaOperacionTextField.inputView = self.pickerFecha;
        self.fechaOperacionTextField.inputAccessoryView = self.barraEditor;
        
        self.numeroTextField.text = self.factura.numero;
        self.cIFTextField.text = self.factura.cIF;
        self.razonSocialTextField.text = self.factura.razonSocial;
        self.baseTextField.text = "\(self.factura.baseImponible!)";
        self.tipoIVATextField.text = "\(self.factura.tipoIva!)";
        self.rectificacionTextField.text = "\(self.factura.rectificacion!)";
        let total = self.factura.baseImponible! + self.factura.baseImponible!*Float(self.factura.tipoIva!)/100.0 - self.factura.rectificacion!;
        self.totalTextField.text = "\(total)"
        
        self.pickerFecha.date = (self.factura.fechaDeExpedicion!)
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        
        if let fecha = self.factura.fechaDeExpedicion
        {
            self.fechaExpedicionTextField.text = formatoFecha.string(from: fecha);
        }
        if let fecha = self.factura.fechaDeOperacion
        {
            self.fechaOperacionTextField.text = formatoFecha.string(from: fecha);
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setEditing(true, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - PICKER MANAGEMET
    
    /////////////////////////////////////////
    // MÉTODOS DE GESTIÓN DEL PICKER FECHA //
    /////////////////////////////////////////
    @IBAction func botonDonePulsado(_ sender: Any) {
        if self.campoTextoActual == self.fechaExpedicionTextField
        {
            self.fechaOperacionTextField.becomeFirstResponder();
        }
        else if self.campoTextoActual == fechaOperacionTextField
        {
            self.cIFTextField.becomeFirstResponder();
        }
        else
        {
            self.campoTextoActual?.resignFirstResponder();
        }
    }
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        if self.campoTextoActual == self.fechaExpedicionTextField
        {
            self.fechaExpedicionTextField.text = formatoFecha.string(from: self.pickerFecha.date);
        }
        else if self.campoTextoActual == self.fechaOperacionTextField
        {
            self.fechaOperacionTextField.text = formatoFecha.string(from: self.pickerFecha.date);
        }
        else
        {
            self.campoTextoActual?.resignFirstResponder();
        }
    }

    ////////////////////////////
    // MÉTODOS DE LOS BOTONES //
    ////////////////////////////
    
    // MARK: - BOTONES
    @IBAction func botonCancelPulsado(_ sender: Any) {
        self.factura.conceptos = self.copiaConceptos;
        self.delegado?.cancelar();
    }
    
    @IBAction func botonGuardarPulsado(_ sender: Any) {
        /// Durante el botón guardado, actualizamos los valores desde las vistas al objeto de trabajo
        self.factura.numero = self.numeroTextField.text!;
        self.factura.cIF = self.cIFTextField.text!;
        self.factura.razonSocial = self.razonSocialTextField.text!;
        
        for i in 0 ..< listaConceptos.count
        {
            self.factura.conceptos![i] = self.listaConceptos[i].text!;
        }
        
        self.factura.baseImponible = Float(self.baseTextField.text!);
        self.factura.tipoIva = Int(self.tipoIVATextField.text!);
        self.factura.rectificacion = Float(self.rectificacionTextField.text!);
        
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        self.factura.fechaDeOperacion = formatoFecha.date(from: self.fechaOperacionTextField.text!);
        self.factura.fechaDeExpedicion = formatoFecha.date(from: self.fechaExpedicionTextField.text!);

        // llamamos al delegado que guarda la factura.
        // AMBAS VISTAS TIENEN QUE IMPLEMENTAR EL DELEGADO
        self.delegado?.guardarFactura(self.factura);
    }

    
    // MARK - TEXT FIELD DELEGATE
    
    //////////////////////////////////////
    // MÉTODOS DELEGADOS DEL TEXT FIELD //
    //////////////////////////////////////
    
    ///////////////////////////////////////////////////////////////////////////
    // TODOS LOS UIVIEW TIENEN DESIGNADO COMO DELEGADO AL PROPIO CONTROLADOR //
    // ESTO SE HACE DESDE EL STORYBOARD                                      //
    // POR CADA ESPECIALIZACIÓN QUE SE QUIERA HACER SE DEBE IMPLEMENTAR      //
    // PRIMERO LA DETECCIÓN DEL CAMPO EN EL QUE ESTAMOS Y LUEGO EL MÉTODO    //
    ///////////////////////////////////////////////////////////////////////////
    
    /// Gestión del 'return' en las vistas textfield.
    /// Se cede el fóco al siguiente campo excepto el último que simplemente renuncia a él.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.numeroTextField
        {
            self.fechaExpedicionTextField.becomeFirstResponder();
        }
        else if textField == self.cIFTextField
        {
            self.razonSocialTextField.becomeFirstResponder();
        }
        else if textField == self.razonSocialTextField
        {
            /// SI LISTA DE CONCEPTOS NO ESTÁ VACÍA LE DAMOS EL FOCO AL PRIMERO
            /// $$$ LA LISTA NO DEBERÍA ESTAR NUNCA VACÍA PORQUE SIEMPRE DEBE TENER AL MENOS EL CAMPO "NUEVO"
            /// SI ESTÁ VACÍA PASAMOS AL SIGUIENTE
            if self.listaConceptos.count == 0
            {
                self.baseTextField.becomeFirstResponder();
            }
            else
            {
                self.listaConceptos.first?.becomeFirstResponder();
            }
        }
        /// SI ESTAMOS EN EL ÚLTIMO OBJETO DE LA LISTA PASAMOS AL SIGUIENTE
        else if textField == self.listaConceptos.last
        {
            self.campoTextoNuevo!.becomeFirstResponder();
        }
        /// SI ESTAMOS EN CUALQUIER OBJETO DE LA LISTA (EL ÚLTIMO, EN TEORÍA, SE HA PROCESADO YA)
        /// LE DAMOS FOCO AL SIGUIENTE
        else if self.listaConceptos.contains(textField)
        {
            self.listaConceptos[self.listaConceptos.index(of: textField)!+1].becomeFirstResponder();
        }
        else if textField == campoTextoNuevo
        {
            ///$$$ CÓDIGO DE CREAR NUEVO CAMPO
            self.baseTextField.becomeFirstResponder();
        }
        else if textField == self.baseTextField
        {
            self.tipoIVATextField.becomeFirstResponder();
        }
        else if textField == self.tipoIVATextField
        {
            self.rectificacionTextField.becomeFirstResponder();
        }
        else if textField == self.rectificacionTextField
        {
            self.ficheroTextField.becomeFirstResponder();
        }
        else if textField == self.ficheroTextField
        {
            self.ficheroTextField.resignFirstResponder();
        }
        else
        {
            textField.resignFirstResponder();
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.campoTextoActual = textField;
    }

    // MARK: - Table view data source
    
    /////////////////////////////////////////////
    /// MÉTODOS DE CONSTRUCCIÓN DE TABLE VIEW ///
    /////////////////////////////////////////////
    
    // Número de filas por sección
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1
        {
            return self.factura.conceptos!.count + 1;
        }
        else
        {
            return super.tableView(tableView, numberOfRowsInSection: section);
        }
    }

    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.0;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1
        {
            if self.factura.conceptos!.count > 0 && indexPath.row < self.factura.conceptos!.count
            {
                let cell : ConceptoCell = tableView.dequeueReusableCell(withIdentifier: "ConceptoCell") as! ConceptoCell;
                cell.conceptoTextView.text = self.factura.conceptos![indexPath.row];
                cell.conceptoTextView.delegate = self;
                
                self.listaConceptos.append(cell.conceptoTextView);
                
                return cell;
            }
            else
            {
                let cell : ConceptoCell = tableView.dequeueReusableCell(withIdentifier: "ConceptoCell") as! ConceptoCell;
                self.campoTextoNuevo = cell.conceptoTextView;
                cell.conceptoTextView.delegate = self;
                return cell;
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath);
    }

    /// DEFINICIÓN DE LOS ESTILOS DE LA TABLA SEGÚN EL INDEX PATH.
    /// $$$$ FALTA POR DEFINIR LA ÚLTIMA CELDA DE AÑADIR QUE TENDRÁ UN BOTÓN DE EDICIÓN $$$$
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 && indexPath.row < self.listaConceptos.count
        {
            return UITableViewCellEditingStyle.delete;
        }
        else if indexPath.section == 1 && indexPath.row == self.listaConceptos.count
        {
            return UITableViewCellEditingStyle.insert;
        }
        
        return UITableViewCellEditingStyle.none;
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            /// BORRAMOS EL ELEMENTO DE LA LISTA DE CONCEPTOS
            self.listaConceptos.remove(at: indexPath.row);
            self.factura.conceptos!.remove(at: indexPath.row);
            /// REAJUSTAMOS LA VISTA DE TABLA
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            /// INSERTAMOS UNA NUEVA CELDA EN EL TABLE VIEW Y EN LA LISTA DE CONCEPTOS.
            //let cell : ConceptoCell = ConceptoCell(style: UITableViewCellStyle.default, reuseIdentifier: "ConceptoCell");
            let cell : ConceptoCell = tableView.dequeueReusableCell(withIdentifier: "ConceptoCell") as! ConceptoCell;
            cell.conceptoTextView.text = self.campoTextoNuevo!.text;
            self.campoTextoNuevo!.text = "";
            self.campoTextoNuevo?.delegate = self;
            self.factura.conceptos!.insert(cell.conceptoTextView.text!, at: indexPath.row);
            tableView.insertRows(at: [indexPath], with: .fade);
        }    
    }
}

