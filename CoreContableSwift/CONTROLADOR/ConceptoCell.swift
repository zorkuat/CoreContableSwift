//
//  ConceptoCell.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit
/**
 # Celda propia "customizada"
 
 Celda que contiene un TextFieldView interno con forzado de márgenes a cero arriba y abajo y con un margen de 40 (para dejar espacio al botón de edición) y 10 lateral derecho.
 Se define la celda con un tamaño enorme que luego ajustará el tableView.
 */
class ConceptoCell: UITableViewCell {

    @IBOutlet weak var conceptoTextView: UITextField!

    /**
     # MÉTODO INIT?
     Gestor obligado para el alamacenaje y recuperación interna del xib.
     
     * Parameters:
        - coder:NSCoder Objeto codificador de recuperación del xib. Por defecto.
     */
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder);
    }

    /**
     # MÉTODO INIT
     
     Inicializador de la celda vía estilo. Se necesita que exista un identificador registrado en el TABLEVIEW de la celda para que pueda invocarse.
     */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.conceptoTextView = UITextField(frame: CGRect(x: 40, y: 0, width: 400, height: 45));
        self.conceptoTextView.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 10);
        let tamFont : Float = 14.0;
        let fontStyle : UIFont = UIFont(descriptor: (self.conceptoTextView.font?.fontDescriptor)!, size: CGFloat(tamFont));
        self.conceptoTextView.font = fontStyle;
        
        self.addSubview(self.conceptoTextView);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
