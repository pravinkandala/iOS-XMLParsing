//
//  CustomTableViewCell.swift
//  XMLParsing
//
//  Created by Pravin Kandala on 2/8/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
       
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
