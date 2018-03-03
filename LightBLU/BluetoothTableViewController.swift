//
//  BluetoothTableViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 3/2/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothTableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let NAME = "CSR1010"
    let B_UUID =
        CBUUID(string: "24C6F950-039E-A382-09F2-ADAA64BD6EF8")
    let BSERVICE_UUID =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    var cell = [String]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cell.count)
        return cell.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        cells.textLabel?.text = cell[indexPath.row]
        print(cells)
        return cells
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is ON.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            print("Bluetooth not available.")
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is Off.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
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
    
   
    /* func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
     let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
     as? NSString
     print("hello:\(peripheral)")
     /*   if device?.contains(NAME) == true{
     self.manager.stopScan()
     
     self.peripheral = peripheral
     self.peripheral.delegate = self
     
     manager.connect(peripheral, options: nil)
     }*/
     }*/
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        cell.append(String(describing: peripheral.identifier))
        
        print("welcome:\(cell)")
        print(cell.count)
      
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey )
            as? NSString
       self.tableView.reloadData()
        //CBAdvertisementDataLocalNameKey
        
     
       
        if device?.contains(String(describing: B_UUID)) == true{
//        var peripherals = [CBPeripheral]()
//        if (!peripherals.contains(peripheral)) {
//
//            let localName = peripheral.name
//            print("\(String(describing: localName))" )
//            peripherals.append(peripheral)
//           // tableView.reloadData()
            print("23454556666")
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
            
        }
        else
        {
            print("no UUID")
        }
        }
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        print("CONNECTED")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, for: thisService)
            
            if service.uuid == BSERVICE_UUID {
             peripheral.discoverCharacteristics(nil, for: thisService)
             }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print(thisCharacteristic.uuid)
            if thisCharacteristic.uuid == B_UUID {
                self.peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var _:UInt32 = 0;
        if characteristic.uuid == B_UUID {
            print(characteristic.value!)
            //characteristic.value!.getBytes(&count, length: sizeof(UInt32))
            //labelCount.text = NSString(format: "%llu", count) as String
        }
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
