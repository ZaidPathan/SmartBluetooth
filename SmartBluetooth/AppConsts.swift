//
//  AppConsts.swift
//  SmartBluetooth
//
//  Created by Zaid Pathan on 24/10/18.
//  Copyright © 2018 ZaidPathan. All rights reserved.
//

import UIKit

struct AppConsts {
    public static let UUID: [String:String] = [
        "2A37" : "Heart Rate",
        "2A19" : "Battery Level",
        "2A2B" : "Current Time",
        "2A29" : "Manufacturer",
        "2A8A" : "First Name",
        "2A90" : "Last Name",
        "2A8C" : "Gender"
    ]
    
    public struct CellId{
        public static let connectCell = "ConnectCell"
        public static let detailCell = "DetailCell"
    }
    
    public struct SegueId{
        public static let toDetailsVC = "toDetailsVC"
    }
}
