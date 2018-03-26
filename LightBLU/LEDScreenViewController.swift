//
//  LEDScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore
import AWSCore
import AWSCognito
import CoreBluetooth


class LEDScreenViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,
                            CBCentralManagerDelegate, CBPeripheralDelegate, UITextFieldDelegate {
   //let vc1 = DeviceViewController.self

    var name: String = " "
    var NAME: String = "LIGHT BLU"
    let B_UUID =
        CBUUID(string: "0x1802")
    //0000AB07-D102-11E1-9B23-00025B00A5A5
    let Device = CBUUID(string: "0x1800")
    let Devicec = CBUUID(string: "0x2A00")
    let BSERVICE_UUID =
        CBUUID(string: "0000AB05-D102-11E1-9B23-00025B00A5A5")
        
    var sliderval = 0
    
    let dname: String = "welcome"
   //let DynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    @IBOutlet weak var switchval: UISwitch!
    @IBOutlet weak var idval: UITextField!
    
    @IBAction func Slideraction(_ sender: UISlider){
        sender.maximumValue = 100.0
        sender.minimumValue = 55.0
        sliderval = Int(sender.value)
        //var st = String(format:"%2X", sliderval)
    
        print(sliderval)
    }
    @IBOutlet weak var coloval: UITextField!
    @IBOutlet var colorval: UIView!
    @IBOutlet var intensityval: UIView!
    let cval = ["Red", "Blue","Green", "White"]
    
     var pickerView = UIPickerView()
    override func viewDidLoad() {
        
       
            self.navigationItem.title = "LED SCREEN";
            super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lb5")!)
//        let backgroundImageView = UIImageView(image: UIImage(named: "lb5"))
//        backgroundImageView.frame = view.frame
//        backgroundImageView.contentMode = .scaleAspectFill
//        view.addSubview(backgroundImageView)
//        view.sendSubview(toBack: backgroundImageView)
        
        
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "123.jpg")
//        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
//        self.view.insertSubview(backgroundImage, at: 0)
             //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "123.jpg")!)
            idval.text = "LIGHT BLU "
            //print("hlsajhljrhfasfg:\(vc.name)")
            pickUp(coloval)
        
           createid()
            readval()
       
        // Do any additional setup after loading the view.
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is ON.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            //self.present(alertController, animated: true, completion: nil)
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
    var peripheral:CBPeripheral!
    
    public func createid() {
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
//                                                                identityPoolId:"us-east-2:0c1abe18-9c04-48d9-a362-f4cdb698834f")
//
//        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
//
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
//
       
      
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models
        let newsItem: Sample = Sample()
        
        newsItem.userid = "welcome"
            //AWSIdentityManager.default().identityId

        //Save a new item
        print("value for db:\(newsItem.userid)")
        dynamoDbObjectMapper.save(newsItem, completionHandler: {
            (error: Error?) -> Void in
           // NSLog((error as! NSString) as String)
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        // Initialize the Cognito Sync client
        let syncClient = AWSCognito.default()
        
        // Create a record in a dataset and synchronize with the server
        let dataset = syncClient.openOrCreateDataset("myDataset")
        dataset.setString("newsItem.userid as String!", forKey:"IdValue")
        print(" saved to cognito")
        dataset.synchronize().continueWith {(task: AWSTask!) -> AnyObject! in
            // Your handler code here
            return nil
            
        }
}
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
            //perip.append(peripherals)
        }
       // self.tableView.reloadData()
        /* let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey )
         as? NSString
         print(String(describing: device))
         //CBAdvertisementDataLocalNameKey
         
         */
        if(peripheral.name != nil)
        {
            name = peripheral.name!
             idval?.text = name
            if (peripheral.name == "LIGHT BLU")
            {
                //self.sublabel.text = "Connected"
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
            //peripheral.discoverCharacteristics(nil, for: thisService)
            print("in service:\(thisService)")
            if service.uuid == BSERVICE_UUID{
                //if service.uuid == Device{
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("in characteristics")
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print(thisCharacteristic.uuid)
            if thisCharacteristic.uuid == B_UUID{
                //if thisCharacteristic.uuid == Devicec{
                //let ch = thisCharacteristic
                print("found matching characteristic")
                peripherals.setNotifyValue(true, for: thisCharacteristic)
                //self.peripherals.delegate = self
                if thisCharacteristic.properties.contains(.read) {
                    print("\(thisCharacteristic.uuid): properties contains .read")
                }
                if thisCharacteristic.properties.contains(.notify) {
                    print("\(thisCharacteristic.uuid): properties contains .notify")
                }
                if thisCharacteristic.properties.contains(.write) {
                    print("\(thisCharacteristic.uuid): properties contains .write")
                }
                
                //peripheral.readValue(for: thisCharacteristic)
                //peripheral.setNotifyValue(true, for: thisCharacteristic)
                //thisCharacteristic.value = "tytyty"
                print(thisCharacteristic as Any)
                /// writting data to peripheral device
                //let d = "FF0000"
                if(idval.text != nil)
                {
                    if(switchval.isOn)
                    {
                        if(coloval.text != nil)
                        {
                            switch(coloval?.text)
                            {
                               
                            case "Red"?:  
                                        var st = String(format:"%2X", 100)
                                        var value: [UInt8] = [0xFF, 0x00, 0x00]
                                        let data = NSData(bytes: &value, length: value.count) as Data
                            //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                                        peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                                        peripheral.readValue(for: thisCharacteristic)
                                        break
                                
                            case "Blue"?: var value: [UInt8] = [0x00, 0x00, 0xFF]
                                            let data = NSData(bytes: &value, length: value.count) as Data
                            //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                                            peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                                            peripheral.readValue(for: thisCharacteristic)
                            
                                            break
                            case "Green"?: var value: [UInt8] = [0x00, 0xFF, 0x00]
                                            let data = NSData(bytes: &value, length: value.count) as Data
                                            //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                                            peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                                            peripheral.readValue(for: thisCharacteristic)
                            
                                            break
                            case "White"?: var value: [UInt8] = [0xFF, 0xFF, 0xFF]
                                            let data = NSData(bytes: &value, length: value.count) as Data
                                            //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                                            peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                                            peripheral.readValue(for: thisCharacteristic)
                            
                                break
                                
                            case .none: break
                                
                            case .some(_): break
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        //print("char value:\(characteristic.value!)")
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        
        print("characteristic uuid: \(characteristic.uuid), value: \(String(describing: characteristic.value))")
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if let error = error {
            print("error: \(String(describing: error))")
            return
        }
        print( characteristic)
        print("Succeeded!")
        manager.cancelPeripheralConnection(peripheral)
    }
    func readval() {
       
        
        // Initialize the Cognito Sync client
       
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let newsItem: Sample = Sample();
        //newsItem._userid = AWSIdentityManager.default().identityId
        
        dynamoDbObjectMapper.load(Sample.self, hashKey: newsItem.userid, rangeKey: "userid",
                  completionHandler: {
                (objectModel: AWSDynamoDBObjectModel?, error: Error?) -> Void in
                    print("Checking :\(newsItem.userid as String)")
                if let error = error {
                    print("Amazon DynamoDB Read Error: \(error)")
                    return
                }
                print("An item was read.")
        })
        
        let syncClient = AWSCognito.default()
        
        // Create a record in a dataset and synchronize with the server
        let dataset = syncClient.openOrCreateDataset("myDataset2")
        dataset.setString("newsItem.userid as String!", forKey:"ReadValue")
        print(" read to cognito: \(newsItem.userid)")
        dataset.synchronize().continueWith {(task: AWSTask!) -> AnyObject! in
            // Your handler code here
            return nil
            
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return cval.count;
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cval[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coloval.text = cval[row]
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        coloval.inputView = pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idval.resignFirstResponder()
        return true
    }

    
    @objc  public func doneClick() {
        coloval.resignFirstResponder()
    }
    @objc public func cancelClick() {
        coloval.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(coloval)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveBtn(_ sender: Any) {
        let id = idval.text
        
        if((id?.isEmpty)!)
        {
//            let alertController = UIAlertController(title: "Alert", message:
//                "Please enter ID ", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//            self.present(alertController, animated: true, completion: nil)
           
        }
        else if(switchval.isOn)
        {      let id = coloval.text
                if((id?.isEmpty)!)
                {
                    let alertController = UIAlertController(title: "Alert", message:
                        "Please Select Color.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
              
                else
                {
                      manager = CBCentralManager(delegate: self, queue: nil)
                }
        }
        else
        {let alertController = UIAlertController(title: "Alert", message:
                "Please On the Switch.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)}
        }
    
   
}
