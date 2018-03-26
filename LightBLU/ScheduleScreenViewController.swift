//
//  ScheduleScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import UserNotifications

class ScheduleScreenViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{
    let colorval = ["Yellow", "Red", "Blue","Green","White","Orange","Black"]
    var pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    var datee = DateComponents()
   
    @IBOutlet weak var schedulertitle: UINavigationBar!
    @IBOutlet weak var alarmtextfield: UITextField!
    @IBOutlet weak var intensitytextfield: UITextField!
    @IBOutlet weak var colortextfield: UITextField!
    @IBOutlet weak var Id: UILabel!
    @IBOutlet weak var Idtextfield: UITextField!
    @IBAction func Switch(_ sender: Any) {
    
        print(" need to take action")
    
    }
    
    
  
    
    
   
    override func viewDidLoad() {
        self.navigationItem.title = "Scheduler";
        super.viewDidLoad()
        
     self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lb5")!)
        
//        let backgroundImageView = UIImageView(image: UIImage(named: "lb5"))
//        backgroundImageView.frame = view.frame
//        backgroundImageView.contentMode = .scaleAspectFill
//        view.addSubview(backgroundImageView)
//        view.sendSubview(toBack: backgroundImageView)
        
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:{ didAllow , error in
            
        })
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
             pickUp(colortextfield)
        showDatePicker()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return colorval.count;
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorval[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colortextfield.text = colorval[row]
    }
    
    func pickUp(_ textField : UITextField){
    
    // UIPickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.backgroundColor = UIColor.white
    colortextfield.inputView = pickerView
    
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
    
    
    @objc  public func doneClick() {
        colortextfield.resignFirstResponder()
    }
     @objc public func cancelClick() {
        colortextfield.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(colortextfield)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        alarmtextfield.inputAccessoryView = toolbar
        alarmtextfield.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        //formatter.timeStyle = DateFormatter.Style.short
        
        alarmtextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Idtextfield.resignFirstResponder()
        return true
    }
    @objc func sendcolor (_ sender: Any)
    {
        print(" Time triggered")
    }
    
    
    @IBAction func SliderActn(_ sender: UISlider) {
        
        print(sender.value)
    }
    @IBAction func savebtn(_ sender: Any) {
        
        print("saved")
        let triggerDaily = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute,], from: datePicker.date)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
        
        let alarmId = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = " Your Request to turn light ON is completed"
        //content.sound = UNNotificationSound.init(named: "your sound filename.mp3")
        content.categoryIdentifier = alarmId
        
        let request = UNNotificationRequest(identifier: "alarmIdentifier", content: content, trigger: trigger)
        
        //print("alarm identi   : \(alarmIdentifier)")
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().add(request) {(error) in
            
            if let error = error {
                print("Uh oh! i had an error: \(error)")
            }
        }
        let timer = Timer(fireAt: datePicker.date, interval: 0, target: self, selector: #selector(self.sendcolor), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
}

