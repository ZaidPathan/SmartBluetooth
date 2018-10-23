//
//  BLEManager.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 16/10/18.
//  Copyright © 2018 Zaid Pathan. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject {
    static let shared = BLEManager()
    var centralManager: CBCentralManager?
    
    var peripherals: [CBPeripheral] = []
    
    override init() {
//        centralManager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "SmartBluetooth"])
//        super.init()
//        centralManager?.delegate = self
    }
    
    func disconnectAll() {
        for p in peripherals {
            
        }
    }
}


extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.debugDescription)
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
            centralManager?.stopScan()
        case .poweredOn:
            print("poweredOn")
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        print(peripheral.services.debugDescription)
        if !peripherals.contains(peripheral) {
            //            print("Adding: \(peripheral.debugDescription)")
            peripheral.delegate = self
            peripherals.append(peripheral)
            let indexPath = IndexPath(row: peripherals.count - 1, section: 0)
//            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
//            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("didConnect peripheral")
//        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect peripheral")
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState peripheral")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral peripheral")
//        tableView.reloadData()
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //        print(peripheral.services.debugDescription)
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //        print(service.characteristics.debugDescription)
        //        print(error)
        
        guard let chars = service.characteristics else { return }
        for charct in chars {
            peripheral.readValue(for: charct)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        let str = String(bytes: value, encoding: String.Encoding.utf8)
        
        print(str)
    }
}
