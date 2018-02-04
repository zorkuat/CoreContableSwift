//
//  ConceptoCell.swift
//  CoreContableSwift
//
//  Created by cice on 2/2/18.
//  Copyright © 2018 TATINC. All rights reserved.
//

import UIKit

class ConceptoCell: UITableViewCell {

    @IBOutlet weak var conceptoTextView: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder);

    }

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
