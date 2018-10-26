//
//  DetailsVC.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 24/10/18.
//  Copyright © 2018 ZaidPathan. All rights reserved.
//

import UIKit

class DetailsVC: UITableViewController, getDataDelegate {
    
    var connectVC: UIViewController?
    
    var uuidArray: [String] = []
    var valueArray: [String] = []
    var peripheral: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = connectVC as? ConnectVC
        vc?.delegate = self
        self.title = "Details"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConsts.CellId.detailCell, for: indexPath) as? DetailCell
        if AppConsts.UUID.keys.contains(uuidArray[indexPath.row]){
            cell?.service.text = AppConsts.UUID[uuidArray[indexPath.row]]
        } else {
            cell?.service.text = "Custom Service"
        }

        cell?.value.text = valueArray[indexPath.row]
        return cell!
    }
  
    // MARK: Delegate Method
    func getCharacteristics(bluetoothName: String, uuid: String, value: String) {
        if bluetoothName == peripheral, !value.isEmpty{
            if uuidArray.contains(uuid){
                if let index: Int = uuidArray.lastIndex(of: uuid) {
                    valueArray.remove(at: index)
                    valueArray.insert(value, at: index)
                }
            } else {
                uuidArray.append(uuid)
                valueArray.append(value)
            }
        }
        tableView.reloadData()
    }
    
}

