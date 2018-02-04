//
//  ListadoFacturasTableViewController.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

/**
 # CLASE ListadoFacturasTableViewController
 
 Clase de la vista principal. Navegador tipo tabla. Hereda de UITableViewController
 
 Delegado de EditarFacturasDelegate.
 
 Vista de carga del listado de facturas con la vista de celda estandar por defecto.
 
 ## Funcionalidades:
 * Boton edit: carga de menú básico de borrado y añadido de elementos.
 * Boton +: Añadido de nuevo elemento. Transita a la vista de edición.
 * Selección de fila: transición a la vista de detalle de la factura.
 */

class ListadoFacturasTableViewController: UITableViewController, EditarFacturaDelegate {
    
    /// CARGA DE VISTA. Creamos la base de datos interna que se relena con datos dummies.
    var factura = Factura.init();
    var bbdd = BBDD.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /// Asignación del botón de la barra de navegación izquierda (no asignada en el storyboard) al botón edit.
        /// Sirve para la edición inmediata (funciones quick de borrado e insercción)
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView.reloadData();
    }
    
    // MARK: - Table view data source
    /////////////////////////////////////////////////////////////////
    // OVERRIDING de funciones básicas del controlador Table View. //
    /////////////////////////////////////////////////////////////////
    
    // Definición del número de secciones
    // A falta de definir cuantas secciones: 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // Deficinión del número de filas
    // Una fila por cada elemento de la tabla más el elemento de edición.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bbdd.facturas.count + 1
    }

    /// Método de mostrado de datos por fila:
    /// PRE: bbdd != NIL
    /// POST: indexPath.i.cell.contenidos[...].TextLabel.Text == bbdd.i.contenidos[...].contenido
    /// POST: if indexPath.i+1 -> cell.contenidos == nuevoContacto
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        if indexPath.row < self.bbdd.facturas.count {
            factura = self.bbdd.facturas[indexPath.row];
            cell.textLabel?.text = factura.numero;
            let total = factura.baseImponible! + factura.baseImponible!*Float(factura.tipoIva!)/100.0;
            cell.detailTextLabel?.text = "\(total)";
        }
        else
        {
            cell.textLabel?.text = "Nueva Factura";
            cell.detailTextLabel?.text = "";
        }

        return cell
    }

    /// Si se selecciona una celda se lanza la transición.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < self.bbdd.facturas.count)
        {
            self.performSegue(withIdentifier: "verFactura", sender: nil);
        }
        else
        {
            self.performSegue(withIdentifier: "anadirFactura", sender: nil);
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /// Métodos quicksort para edición rápida.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row < self.bbdd.facturas.count)
        {
            return UITableViewCellEditingStyle.delete;
        }
        else
        {
            return UITableViewCellEditingStyle.insert;
        }
    }
    
    // MÉTODO PARA LA EDICIÓN EN QUICKSHORT
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.bbdd.facturas.remove(at: Int(indexPath.row));
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let nuevaFactura : Factura = Factura();
            self.bbdd.facturas.append(nuevaFactura);
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.right);
        }    
    }

    // MARK: - Navigation

    /////////////////////////////////////////////
    /// CREAR LA TRANSICIÓN PARA VER CONTACTO ///
    /////////////////////////////////////////////
    // Este método es el Adolfo Suárez de los métodos: Prepara la Transición.
    // PRE: vistaSiguiente == verFactura
    // POST: enviar.factura -> vistaSiguiente
    
    // Quicksort adding
    // PRE: vistaSiguiente == crearContacto
    // POST: vistaSiguiente.selfdelegate
    
    // PRE: vistaSiguiente == añadirContacto
    // POST: vista
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        /// CASO DE TRANSICIÓN A LA VISTA DE EDICIÓN
        if segue.identifier == "verFactura"
        {
            // Generamos una variable auxiliar recuperando el contacto desde la fila seleccionada ppor el usuario.
            let filaSeleccionada = self.tableView.indexPathForSelectedRow!.row;
            
            let facturaSeleccionada = self.bbdd.facturas[filaSeleccionada];
            
            let escenaDestino = segue.destination as! DetalleFacturaViewController;
            
            // Vamos a pasar la información. Aquí la factura es la INTERNA de gestión de la escena destino.
            escenaDestino.factura = facturaSeleccionada;
        }
        
        /// CASO DE TRANSICIÓN A LA PANTALLA QUICKSHORT DE EDICIÓN
        else if segue.identifier == "anadirFactura"
        {
            // En el caso de que creemos la factura desde la lista, nos autoasignamos el delegado para implementar los métodos del
            // protocolo. Asignación directa.
            // Ahora mismo daría lo mismo.
            let navController = segue.destination as! UINavigationController;
            let escenaDestino = navController.topViewController as! EditarFacturaTableViewController;
            
            let filaSeleccionada = self.tableView.indexPathForSelectedRow!.row;
            let facturaSeleccionada = self.bbdd.facturas[filaSeleccionada];
            escenaDestino.factura = facturaSeleccionada;
        }
    
    }

    // MARK: - EditarFacturaDelegate
    
    func guardarFactura(_ factura: Factura) {
        self.factura = factura;
        self.bbdd.facturas.append(factura);
        self.dismiss(animated: true, completion: nil);
    }
    
    func cancelar() {
        self.dismiss(animated: true, completion: nil);
    }
}
