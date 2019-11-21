//
//  ParticalPeripheral.swift
//  HappySlapGiving
//
//  Created by 彭睿诚 on 2019/10/8.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {
    
    /// MARK: - Particle LED services and charcteristics Identifiers
    
    public static let particleLEDServiceUUID     = CBUUID.init(string: "ffe0")
    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "ffe1")
}
