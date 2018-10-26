//
//  DetailCell.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 24/10/18.
//  Copyright © 2018 ZaidPathan. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet var service: UILabel!
    @IBOutlet var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
