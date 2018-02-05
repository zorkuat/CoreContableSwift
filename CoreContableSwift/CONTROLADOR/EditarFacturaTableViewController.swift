//
//  EditarFacturaTableViewController.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

/**

 # CLASE EditarFacturaTableViewController
 
 Clase de la vista de Edición. Navegador tipo tabla. Hereda de UITableViewController
 
 Llama al delegado EditarFacturasDelegate para la salvaguarda de los datos.
 
 Vista de edición del detalle de facturas.
 
 ## Funcionalidades:
 * Boton save: Salva la información guardada en la base de datos principal y vuelve a la vista de llamada (de detalle o de listado, según quien haya llamado).
 * Boton Cancel: Regresa sin guardar a la vista anterior.
 * Añadido de información de datos simples: Carga manual vía texto o picker.
 * Gestión de datos multivaluados: Inclusión, modificación y borrado de nuevos campos multivaluados vía celdas editables nuevas.

 */
class EditarFacturaTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    /// Correspondencias con las vistas del mainstoryboard
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
    
    /// Correspondencias con las vistas del picker y auiliar del mainstoryboard
    @IBOutlet var pickerFecha: UIDatePicker!
    @IBOutlet var barraEditor: UIToolbar!
    
    /// Objeto de trabajo de interfaces de entrada de los datos multivaluados.
    var listaConceptos : Array<UITextField> = [];
    
    /// Referencia al campo de texto actual seleccionado.
    var campoTextoActual : UITextField?;
    
    /// referencia al campo de texto "nuevo" de la lista de celdas de conceptos
    var campoTextoNuevo : UITextField?;
 
    /// Objeto de trabajo de factura actual
    var factura : Factura = Factura();
    
    /// Copia guardada de los conceptos para salvaguarda en caso de cancelación
    var copiaConceptos : Array<String> = [];
 
    /// Referencia al delegado de guarda de factura.
    weak var delegado : EditarFacturaDelegate?;
    
    ////////////////////////////////////
    // MÉTODO DE CARGA DE LAS VISTAS. //
    ///////////////////////////////////////////////////////////////////////////////////////
    // Creamos la variable de trabajo local y actualizamos los campos si no son vacíos.  //
    // Asociamos las referencias a vista con los campos de la variable de trabajo local. //
    ///////////////////////////////////////////////////////////////////////////////////////
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    
        /// Registro de la celda customizada para su reutilización.
        tableView.register(ConceptoCell.self, forCellReuseIdentifier: "ConceptoCell");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /// Inicialización del objeto de trabajo conceptos que servirá para salvaguardar en caso de cancelación
        self.copiaConceptos = self.factura.conceptos!;

        /// Enlaces lógicos entre el picker para fecha (más botón accesorio adjunto) y las interfaces de texto
        self.pickerFecha.translatesAutoresizingMaskIntoConstraints = false;
        self.fechaExpedicionTextField.inputView = self.pickerFecha;
        self.fechaExpedicionTextField.inputAccessoryView = self.barraEditor;
        self.fechaOperacionTextField.inputView = self.pickerFecha;
        self.fechaOperacionTextField.inputAccessoryView = self.barraEditor;
        
        /// Enlaces lógicos entre las interfaces de entrada y los datos del objeto de trabajo.
        self.numeroTextField.text = self.factura.numero;
        self.cIFTextField.text = self.factura.cIF;
        self.razonSocialTextField.text = self.factura.razonSocial;
        self.baseTextField.text = "\(self.factura.baseImponible!)";
        self.tipoIVATextField.text = "\(self.factura.tipoIva!)";
        self.rectificacionTextField.text = "\(self.factura.rectificacion!)";
        /// Cálculo del campo computado
        let total = self.factura.baseImponible! + self.factura.baseImponible!*Float(self.factura.tipoIva!)/100.0 - self.factura.rectificacion!;
        self.totalTextField.text = "\(total)"
        
        /// Enlace lógico entre el picker y el dato de trabajo.
        self.pickerFecha.date = (self.factura.fechaDeExpedicion!)
        
        /// Definición del formato de visualización de fecha en las interfaces correspondientes.
        let formatoFecha : DateFormatter = DateFormatter();
        formatoFecha.dateFormat = "dd / MM / yyyy";
        
        /// Enlaces lógicos entre los datos y las interfaces de entrada de datos
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
        /// Establecimiento de la tabla en modo editable.
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
    
    /// Actualización de los valores de selección de fecha
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
    
    /**
     # BOTON CANCEL PULSADO
     
     Método para volver atrás salvaguardando los datos anteriores y deshaciendo la operación.
     Como en realidad, el objeto de trabajo 'factura' no se toca, pero el listado de conceptos si, se restaura la lista de conceptos y se llama al padre.
     El listado de conceptos se utiliza para mantener la estructura dinámica de tabla.
     
     * Parameters:
        - sender: Any Controlador padre y delegado de los métodos Cancelar y guardar
     */
    @IBAction func botonCancelPulsado(_ sender: Any) {
        /// Restauramos conceptos
        self.factura.conceptos = self.copiaConceptos;
        /// Llamamos al método de cancelación del delegado
        self.delegado?.cancelar();
    }
    
    /**
     # BOTON GUARDAR PULSADO
     
     Método para guardar la información en la base de datos principal
     Se recopilan todos los datos desde los campos.
     
     Se guardan los conceptos.
     
     Se llama al delegado.
     
     * Parameters:
        - sender: Any Controlador padre y delegado de los métodos Cancelar y guardar
    */
    @IBAction func botonGuardarPulsado(_ sender: Any) {
        /// Durante el botón guardado, actualizamos los valores desde las vistas al objeto de trabajo
        self.factura.numero = self.numeroTextField.text!;
        self.factura.cIF = self.cIFTextField.text!;
        self.factura.razonSocial = self.razonSocialTextField.text!;
        
        /// Guardamos los conceptos uno a uno
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
    
    /// Si se ha empezado a editar un campo, se establece como campo actual.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.campoTextoActual = textField;
    }

    // MARK: - Table view data source
    
    /////////////////////////////////////////////
    /// MÉTODOS DE CONSTRUCCIÓN DE TABLE VIEW ///
    /////////////////////////////////////////////
    
    /// Número de filas por sección
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

    /// Como se utilizan secciones, es necesario establecer el nivel de sangrado
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1;
    }
    
    /// Se establece el tamaño de la altura como fijo para todas las celdas de la tabla. EL propio TableView Gestiona el scroll.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.0;
    }
    
    /// Inserta una celda en el índice pertinente y la devuelve para su registro.
    /// En este caso no hace falta registrar la celda ya que se registra a la entrada de la construcción de la tabla.
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
    
    /// Override to support conditional editing of the table view.
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
    
    /// Override to support editing the table view.
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
            /// Creamos una celda nueva y actualizamos el campo nuevo en vacío.
            let cell : ConceptoCell = tableView.dequeueReusableCell(withIdentifier: "ConceptoCell") as! ConceptoCell;
            cell.conceptoTextView.text = self.campoTextoNuevo!.text;
            self.campoTextoNuevo!.text = "";
            self.campoTextoNuevo?.delegate = self;
            self.factura.conceptos!.insert(cell.conceptoTextView.text!, at: indexPath.row);
            tableView.insertRows(at: [indexPath], with: .fade);
        }    
    }
}

