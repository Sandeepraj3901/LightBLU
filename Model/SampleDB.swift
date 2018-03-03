//
//  SampleDB.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 3/2/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore
import AWSCore

class SampleDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var bid: String?
    static func dynamoDBTableName() -> String {
        
        return "bid"
        
    }
    
    static func hashKeyAttribute() -> String {
    
        return "bid"
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
