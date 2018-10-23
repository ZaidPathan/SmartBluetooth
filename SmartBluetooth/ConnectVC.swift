//
//  ConnectVC.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 15/10/18.
//  Copyright © 2018 Zaid Pathan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectVC: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let connectCell = "ConnectCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            
        }
        BLEManager.shared.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "SmartBluetooth"])
        
        let nib = UINib(nibName: connectCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: connectCell)
    }
}


extension ConnectVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEManager.shared.peripherals.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConnectCell = (tableView.dequeueReusableCell(withIdentifier: "ConnectCell", for: indexPath) as? ConnectCell)!
        cell.connectButton.tag = indexPath.row
        cell.delegate = self
        cell.lblTitle.text = BLEManager.shared.peripherals[indexPath.row].name ?? BLEManager.shared.peripherals[indexPath.row].identifier.uuidString
        
        cell.lblDesc.text = "\(BLEManager.shared.peripherals[indexPath.row].state.rawValue)"
        
        var bgColor: UIColor = .white
        switch BLEManager.shared.peripherals[indexPath.row].state {
        case .disconnected:
            cell.connectButton.setTitle("Disconnected", for: UIControl.State.normal)
            bgColor = .white
        case .connecting:
            cell.connectButton.setTitle("Connecting...", for: UIControl.State.normal)
            bgColor = .purple
        case .connected:
            cell.connectButton.setTitle("Connected", for: UIControl.State.normal)
            bgColor = .green
        case .disconnecting:
            cell.connectButton.setTitle("Disconnecting...", for: UIControl.State.normal)
            bgColor = .brown
        }
        cell.contentView.backgroundColor = bgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEManager.shared.centralManager?.connect(BLEManager.shared.peripherals[indexPath.row], options: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConnectVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print(central.debugDescription)
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
        case .poweredOn:
            print("poweredOn")
            BLEManager.shared.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral.services.debugDescription)
        if !BLEManager.shared.peripherals.contains(peripheral) {
//            print("Adding: \(peripheral.debugDescription)")
            BLEManager.shared.peripherals.append(peripheral)
            let indexPath = IndexPath(row: BLEManager.shared.peripherals.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("didConnect peripheral")
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect peripheral")
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState peripheral")
        tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral peripheral")
        tableView.reloadData()
    }
}

extension ConnectVC: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print(peripheral.services.debugDescription)
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let chars = service.characteristics else { return }
        for charct in chars {
            peripheral.setNotifyValue(true, for: charct)
            peripheral.readValue(for: charct)
            peripheral.readRSSI()
            if charct.uuid == CBUUID(string: "F000C0E3-0451-4000-B000-000000000000"){
               //peripheral.discoverDescriptors(for: charct)
            let payload: [UInt8] = [UInt8]("0-1111111111".utf8)
//                var data = [UInt8(0x7E), UInt8(0x12), UInt8(0x0C)]
//            for value in payload {
//                data.append(value)
//            }
//            data.append(UInt8(0x12 + 0x0C + 0x0A))
//            data.append(UInt8(0x7E))
            peripheral.writeValue(Data(bytes: [UInt8(0x7E),UInt8(0x12),UInt8(0x0C),payload,UInt8(0x12 + 0x0C + 0x0A),UInt8(0x7E)], count: 1), for: charct, type: CBCharacteristicWriteType.withResponse)
//            peripheral.writeValue(Data(bytes: [], count: 1), for: charct, type: CBCharacteristicWriteType.withResponse)
//            peripheral.writeValue(Data(bytes: [], count: 1), for: charct, type: CBCharacteristicWriteType.withResponse)
//            peripheral.writeValue(Data(bytes: [], count: payload.count), for: charct, type: CBCharacteristicWriteType.withResponse)
//            peripheral.writeValue(Data(bytes: [], count: 1), for: charct, type: CBCharacteristicWriteType.withResponse)
//            peripheral.writeValue(Data(bytes: [], count: 1), for: charct, type: CBCharacteristicWriteType.withResponse)
                
//               peripheral.writeValue("0x5A".data(using: String.Encoding.utf16)!, for: charct, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    //MARK:- Main delegate
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        
        if characteristic.uuid.uuidString == "2A19" {
            print("Battery Level: \(value.first ?? 0)")
        } else if characteristic.uuid.uuidString == "2A2B" {
            guard value.count > 6 else { return }
            let month = value[2]
            let day = value[3]
            let hour = value[4]
            let min = value[5]
            print("Month: \(month) Day: \(day) Hour: \(hour) Min: \(min)")
        } else if characteristic.uuid.uuidString == "2A29" {
            print("Manufacturer: \(String(describing: String(bytes: value, encoding: String.Encoding.utf8)))")
        } else {
            print("Details: \(String(describing: String(bytes: value, encoding: String.Encoding.utf8)))")
            for byte in value {
                print("characteristic UUID:\(characteristic.uuid.uuidString) value: \(byte)")
            }
        }
        
        
//        let str = String(bytes: value, encoding: String.Encoding.utf8)
//
//        print("Data: UUID: \(characteristic.uuid)\nValue: \(str)\n")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
//            print(error.localizedDescription)
        } else {
            guard let value = characteristic.value else { return }
            let str = String(bytes: value, encoding: String.Encoding.utf8)
            print(str)
//            print("Notification: UUID: \(characteristic.uuid)\nValue: \(str)\n")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
//        print(RSSI)
    }

    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        
    }
    
    @available(iOS 11.0, *)
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(error ?? "")
        print(characteristic.value)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        guard let descriptor = characteristic.descriptors else { return }
//        peripheral.setNotifyValue(true, for: characteristic)
//        peripheral.writeValue("vjhvjjv".data(using: String.Encoding.ascii)!, for: descriptor[0])
        
    }
    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension ConnectVC: ConnectCellDelegate {
    func didClick(button: UIButton) {
        let row = button.tag
        BLEManager.shared.centralManager?.connect(BLEManager.shared.peripherals[row], options: nil)
        
    }
}
