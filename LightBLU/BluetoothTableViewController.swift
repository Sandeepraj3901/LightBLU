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
    
    var name: String = " "
    let B_UUID =
        CBUUID(string: "5A8ADD90-A33D-5803-C623-40517908D5EF")
    let BSERVICE_UUID =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    var perip = Array<CBPeripheral>()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(perip.count)
        return perip.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        let peripheral1 = perip[indexPath.row]
        
               cells.textLabel?.text = peripheral1.name
        //print(cells)
        return cells
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
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
    var peripherals:CBPeripheral!
    
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
       
        /*if(cell.contains(String(describing: peripheral.identifier.uuid)) == false && cell.count < 15)
        {
        cell.append(String(describing: peripheral.identifier.uuidString))
        
        print("welcome:\(cell)")
        print(cell.count)
        }*/
        //print(peripherals)
        //print("Discovered: \(String(describing: peripheral.name)) at \(RSSI)")
        //print("AdvertisementData:\(advertisementData)")
        if (peripherals != peripheral && peripheral.name != nil)
        {
            peripherals = peripheral
            print(peripherals)
            perip.append(peripherals)
        }
       self.tableView.reloadData()
       /* let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey )
            as? NSString
        print(String(describing: device))
        //CBAdvertisementDataLocalNameKey
        
     */
       if(peripheral.name != nil)
       {
        name = peripheral.name!
        if peripheral.name == "estimote"
        {
            
            print("Found:\(name)")
            manager.connect(peripherals, options: nil)
            print("23454556666")
            self.manager.stopScan()
            
            self.peripherals = peripheral
            self.peripherals.delegate = self
           
        }
        else
        {
            print("no device found")
            //self.manager.stopScan()
            
            
        }
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.delegate = self
       
        
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
                self.peripherals.setNotifyValue(true, for: thisCharacteristic)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TabletoDevice") {
            let vc = segue.destination as! DeviceViewController
            vc.selectedName = name
        }
    }
    
    
}
