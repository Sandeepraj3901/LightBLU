//
//  LEDScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit

class LEDScreenViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

  
    @IBOutlet weak var switchval: UISwitch!
    @IBOutlet weak var idval: UITextField!
    
    @IBOutlet weak var coloval: UITextField!
    @IBOutlet var colorval: UIView!
    @IBOutlet var intensityval: UIView!
    let cval = ["Yellow", "Red", "Blue","Green","White","Orange","Black"]
    
     var pickerView = UIPickerView()
    override func viewDidLoad() {
        
      
       
            self.navigationItem.title = "LED SCREEN";
            super.viewDidLoad()
            pickUp(coloval)

        // Do any additional setup after loading the view.
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

}
