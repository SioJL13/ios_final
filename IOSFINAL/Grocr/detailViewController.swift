//
//  detailViewController.swift
//  Grocr
//
//  Created by Siomara Jimenez on 11/30/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
  
  var monthName = Int()
  var activityName = String()
  //REFERENCIA A FIREBASE
  let ref = FIRDatabase.database().reference(withPath: "Items")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref.child(String(monthName)).child(activityName).observe(.value, with: { snapshot in
      //print("Hello")
      let val = snapshot.value as? NSDictionary
      let precio = val!["price"] as? String ?? ""
      print("PRECIOOO " + precio)
      
      
    })
    
    // Do any additional setup after loading the view.
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
