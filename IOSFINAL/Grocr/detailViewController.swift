//
//  detailViewController.swift
//  Grocr
//
//  Created by Siomara Jimenez on 11/30/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit
import Eureka

class detailViewController: FormViewController {
  
  var monthName = Int()
  var activityName = String()
  //REFERENCIA A FIREBASE
  let ref = FIRDatabase.database().reference(withPath: "Items")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref.child(String(monthName)).child(activityName).observe(.value, with: { snapshot in
   
      let val = snapshot.value as? NSDictionary
      let precio = val!["price"] as? String ?? ""
      let description = val!["description"] as? String ?? ""
    
      
      self.form = Section("Detalles")
        <<< LabelRow(){ row in
          row.tag = "name"
          row.title = "Actividad"
          row.value = self.activityName
          
          
        }
        <<< TextRow(){ row in
          row.tag = "precio"
          row.title = "Gasto"
          row.value = precio
          row.onCellHighlightChanged({cell, row in
            self.ref.child(String(self.monthName)).child(self.activityName).child("price").setValue(row.value)
          
          })
          
        }
        <<< TextAreaRow("notes") { row in
          row.tag = "descripcion"
          row.placeholder = "Descripcion"
          row.textAreaHeight = .dynamic(initialTextViewHeight: 50)
          row.value = description
          row.onCellHighlightChanged({cell, row in
            self.ref.child(String(self.monthName)).child(self.activityName).child("description").setValue(row.value)
            
          })
        }
        
        +++ Section("Section2")
        /*<<< DateRow(){
          let calendar = NSCalendar.current
          let components = NSDateComponents()
          components.day = 5
          components.month = 10
          components.year = 2016
          
          $0.title = "Date Row"
          $0.value = calendar.date(from: components as DateComponents)
      }*/
    
      //self.form.setValues(["name": self.activityName, "precio": precio, "descripcion": description])
      
      
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
