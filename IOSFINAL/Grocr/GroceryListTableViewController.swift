/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class GroceryListTableViewController: UITableViewController {
  
  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  //Total
  @IBOutlet weak var totalLabel: UILabel!
  var total = 0
  var totalFlag = true
  
  // MARK: Properties
  var items: [GroceryItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  
  //
  let mes = Calendar.current.component(.month, from: Date())
  
  //REFERENCIA A FIREBASE
  let ref = FIRDatabase.database().reference(withPath: "Items")
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    /*userCountBarButtonItem = UIBarButtonItem(title: "1",
     style: .plain,
     target: self,
     action: #selector(userCountButtonDidTouch))
     userCountBarButtonItem.tintColor = UIColor.white
     navigationItem.leftBarButtonItem = userCountBarButtonItem*/
    
    //user = User(uid: "FakeId", email: "hungry@person.foodSSS")
    
    ref.child(String(mes)).observe(.value, with: { snapshot in
      //print(snapshot.value)
      // 2
      var newItems: [GroceryItem] = []
      
      // 3
      for item in snapshot.children {
        // 4
        let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
        newItems.append(groceryItem)
      }
      
      // 5
      self.items = newItems
      self.tableView.reloadData()
      
    })
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let groceryItem = items[indexPath.row]
    
    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = "$ \(groceryItem.price)"
    
    
    if totalFlag {
      self.total = self.total + Int(groceryItem.price)!
      self.totalLabel.text = "$ \(String(self.total))"
    }
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   items.remove(at: indexPath.row)
   tableView.reloadData()
   }
   }*/
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let groceryItem = items[indexPath.row]
      self.total = self.total - Int(groceryItem.price)!
      self.totalLabel.text = "$ \(String(self.total))"
      groceryItem.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let groceryItem = items[indexPath.row]
    print(groceryItem)
    
    //let controller = self.storyboard?.instantiateViewController(withIdentifier: "detalleCelda")
    //self.present(controller!, animated: true, completion: nil)
    
    
    totalFlag = false
    //print("CLICK AQUIII!!!")
    tableView.reloadData()
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Agrega un cargo",
                                  message: "Escribe tu actividad junto su precio",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Salvar",
                                   style: .default) { _ in
                                    
                                    let date = Date()
                                    let calendar = Calendar.current
                                    
                                    let month = calendar.component(.month, from: date)
                                    let day = calendar.component(.day, from: date)
                                    
                                    let mesString = String(month)
                                    
                                    
                                    //1
                                    let firstText = alert.textFields![0] as UITextField
                                    let secondText = alert.textFields![1] as UITextField
                                    
                                    // 2
                                    let groceryItem = GroceryItem(name: firstText.text!,
                                                                  price: secondText.text!,
                                                                  month: month,
                                                                  day: day,
                                                                  description:""
                                    )
                                    
                                    // 3
                                    let groceryItemRef = self.ref.child(mesString).child(firstText.text!.lowercased())
                                    
                                    //4
                                    self.totalFlag = false
                                    self.total = self.total + Int(groceryItem.price)!
                                    self.totalLabel.text = "$ \(String(self.total))"
                                    
                                    // 5
                                    groceryItemRef.setValue(groceryItem.toAnyObject())
    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField{ (textField) in
      textField.placeholder = "Actividad"
    }
    
    alert.addTextField{ (textField) in
      textField.placeholder = "Gasto"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
    
    if segue.identifier == "detalleSegue",
      let destination = segue.destination as? detailViewController,
      let IndexPath = tableView.indexPathForSelectedRow?.row
    {
      let groceryItem = items[IndexPath]
      destination.activityName = groceryItem.name
      destination.monthName = groceryItem.month
      
    }
  }
  
}
