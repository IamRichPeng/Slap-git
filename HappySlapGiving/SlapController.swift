//
//  SlapController.swift
//  HappySlapGiving
//
//  Created by 彭睿诚 on 2019/10/8.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit
import Firebase
import CoreBluetooth
import AVFoundation

class SlapController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    @IBOutlet weak var bigbtn: UIButton!
    
    
    var audioPlayer:AVAudioPlayer?
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    //use characteristic to send message to service(device)
    private var redChar: CBCharacteristic?
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Particle Board")
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("LED service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("count")
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID {
                    print("Red LED characteristic found")
                    redChar = characteristic
                }
            }
        }
    }
    
    private func send_BLE_Data(withCharacteristic characteristic: CBCharacteristic, withValue value: Data){
        // Check if it has the write property
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
            
            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
            
        }
        
    }
    
    @IBAction func SlapLoser(_ sender: Any) {
        let pathToSound = Bundle.main.path(forResource: "Slap", ofType: "wav")
        let url = URL(fileURLWithPath: pathToSound!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            
        }
        print("Data Send!")
        send_BLE_Data(withCharacteristic: redChar!, withValue: Data([1]))
        print(bet!.slaps)
        print(bet!.timestamp)
        updateSlaps()
    }
    
     var bet: Bet?
    
    private func updateSlaps(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postRef = Database.database().reference().child("users/\(uid)/testingpost").child(String(bet!.timestamp)).child("BET/slaps")
        
        bet!.slaps = bet!.slaps - 1
        let slaps = bet!.slaps
        postRef.setValue(slaps)

    }
    
    
    
    
    
    override func viewDidLoad() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        super.viewDidLoad()
        circlebtn(bigbtn)
        bigbtn.addTarget(self, action: #selector(self.changeship), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    func circlebtn(_ object: AnyObject){
        object.layer?.cornerRadius = object.frame.size.width / 2
        object.layer?.masksToBounds = true
    }
    
    @objc fileprivate func changeship(sender:UIButton){
        self.donghua(sender)
    }
    
    fileprivate func donghua(_ viewToAnimato:UIView){
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewToAnimato.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }){(_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimato.transform = CGAffineTransform(scaleX: 1, y: 1)
    }, completion: nil)
}
}
}
