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
    var NAME: String = "LIGHT BLU"
    let B_UUID =
        CBUUID(string: "0000AB07-D102-11E1-9B23-00025B00A5A5")
    
    
    let BSERVICE_UUID =
        CBUUID(string: "0000AB05-D102-11E1-9B23-00025B00A5A5")
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
        print("Discovered: \(String(describing: peripheral)) at \(RSSI)")
        print("AdvertisementData:\(advertisementData)")
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
        if (peripheral.name == "LIGHT BLU")
        {
            let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
                as? NSString
            print("hello:\(peripheral) and \(String(describing: device))")
            if device?.contains(NAME) == true{
            //self.manager.stopScan()
            print("Found:\(name), and \(NAME)")
            //manager.connect(peripherals, options: nil)
            print("23454556666")
                self.peripherals = peripheral
                self.peripherals.delegate = self
                manager.connect(peripherals, options: nil)
                //print(peripherals)
                self.manager.stopScan()
            
            }
            self.peripherals = peripheral
            self.peripherals.delegate = self
           
        }
        else
        {
            print("no device found")
            //self.manager.stopScan()
            
            
        }
       }
       else
        {
            print("no peripheral name")
        }
}
      
        
    
    
    
//    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
//        print("CONNECTED")
//        peripheral.discoverServices(nil)
//        peripheral.delegate = self
//
//
//
//
//    }
    // Called when it succeeded
    func centralManager(_ central: CBCentralManager,
                                 didConnect peripherals: CBPeripheral)
    {
        print(peripherals)
        print("connected!")
        peripherals.delegate = self
        peripherals.discoverServices(nil)
    
        
    }
    // Called when it failed
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?)
    {
        print("failed…")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, for: thisService)
            print("in service:\(thisService)")
            if service.uuid == BSERVICE_UUID {
             peripheral.discoverCharacteristics(nil, for: thisService)
             }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("in characteristics")
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print(thisCharacteristic.uuid)
            if thisCharacteristic.uuid == B_UUID {
                //let ch = thisCharacteristic
                print("found matching characteristic")
                peripherals.setNotifyValue(true, for: thisCharacteristic)
                 self.peripherals.delegate = self
                if thisCharacteristic.properties.contains(.read) {
                    print("\(thisCharacteristic.uuid): properties contains .read")
                }
                if thisCharacteristic.properties.contains(.notify) {
                    print("\(thisCharacteristic.uuid): properties contains .notify")
                }
                if thisCharacteristic.properties.contains(.write) {
                    print("\(thisCharacteristic.uuid): properties contains .write")
                }
                print(thisCharacteristic.value as Any)
                peripherals.readValue(for: thisCharacteristic)
                /// writting data to peripheral device
                //let d = "FF0000"
                let bytes : [UInt8] = [ 0xF, 0xF, 0x00, 0x00, 0x00, 0x00 ]
                let data = Data(bytes:bytes)
               //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                peripherals.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
                 peripherals.readValue(for: thisCharacteristic)
                }
            }
        }
    
    
    
     func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
       
        if characteristic.uuid == B_UUID {
            //print("char value:\(characteristic.value!)")
            if let error = error {
                print("Failed… error: \(error)")
                return
            }

            print("characteristic uuid: \(characteristic.uuid), value: \(String(describing: characteristic.value))")

            }
        }
    
     func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if error != nil {
            print("error: \(String(describing: error))")
            return
        }
        
        print("Succeeded!")
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
