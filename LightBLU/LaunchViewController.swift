//
//  LaunchViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/20/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  
   
    @IBAction func getstarted(_ sender: Any) {
        
       performSegue(withIdentifier: "collectionsegue", sender: self)
    }
    @IBAction func tabbarbtn(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let Imagesarry=[UIImage(named:"1"),UIImage(named:"2"),UIImage(named:"3"),UIImage(named:"4")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Imagesarry.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier:"MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cells.Images.image = Imagesarry[indexPath.row]
        return cells
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
