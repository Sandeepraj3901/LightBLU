//
//  BluetoothScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import CoreBluetooth
let NAME = "CSR1010"
let B_UUID =
    CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
let BSERVICE_UUID =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
class BluetoothScreenViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }

    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func centralManager(
        central: CBCentralManager,
        didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String : AnyObject],
        RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        
        if device?.contains(NAME) == true{
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(
        central: CBCentralManager,
        didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    
    private func peripheral(
        peripheral: CBPeripheral,
        didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == BSERVICE_UUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
 
    
    private func peripheral(
        peripheral: CBPeripheral,
        didDiscoverCharacteristicsForService service: CBService,
        error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == B_UUID {
                self.peripheral.setNotifyValue(
                    true,
                    for: thisCharacteristic
                )
            }
        }
    }
    
    
    private func peripheral(
        peripheral: CBPeripheral,
        didUpdateValueForCharacteristic characteristic: CBCharacteristic,
        error: Error?) {
        var _:UInt32 = 0;
        
        if characteristic.uuid == B_UUID {
            print(characteristic.value!)
            //characteristic.value!.getBytes(&count, length: sizeof(UInt32))
            //labelCount.text = NSString(format: "%llu", count) as String
        }
    }
    
    private func centralManager(
        central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
