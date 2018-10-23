//
//  ConnectCell.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 15/10/18.
//  Copyright © 2018 Zaid Pathan. All rights reserved.
//

import UIKit

protocol ConnectCellDelegate {
    func didClick(button: UIButton)
}

class ConnectCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    var delegate: ConnectCellDelegate?
    
    @IBAction func actionConnect(_ sender: UIButton) {
        delegate?.didClick(button: sender)
    }
}
