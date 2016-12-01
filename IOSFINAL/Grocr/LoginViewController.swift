
import UIKit

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  func shake() {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = 0.6
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    
  }
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    if textFieldLoginEmail.text != "" && textFieldLoginPassword.text != ""{
      FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!, completion: { (user, error) in
        if error == nil{
          self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }else{
          let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
          animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
          animation.duration = 0.6
          animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
          
          self.textFieldLoginEmail.layer.add(animation, forKey: "transform.translation.x")
          self.textFieldLoginPassword.layer.add(animation, forKey: "transform.translation.x")
          
          print("Something went wrong")
        }
        //
      })
      //performSegue(withIdentifier: loginToList, sender: nil)
      
    }
    else{
      print("Empty fields")
      
      let alertController = UIAlertController(title: "Empty fields",
                                              message: "You can't have empty fields",
                                              preferredStyle: .alert)
      
      
      let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        
      }
      
      alertController.addAction(OKAction)
      present(alertController, animated: true, completion: nil)
      
      
      
      
    }
  }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    let emailField = alert.textFields![0].text
                                    let passwordField = alert.textFields![1].text
                                    
                                    FIRAuth.auth()!.createUser(withEmail: emailField!,
                                                               password: passwordField!) { user, error in
                                                                if error == nil {
                                                                  
                                                                  
                                                                  FIRAuth.auth()!.signIn(withEmail: emailField!, password: passwordField!, completion: { (user, error) in
                                                                    self.performSegue(withIdentifier: self.loginToList, sender: nil)
                                                                  })
                                                                  
                                                                }
                                                                else{
                                                                  let alertController = UIAlertController(title: "Empty fields",
                                                                                                          message: "You can't have empty fields",
                                                                                                          preferredStyle: .alert)
                                                                  
                                                                  
                                                                  let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                                                    
                                                                  }
                                                                  
                                                                  alertController.addAction(OKAction)
                                                                  self.present(alertController, animated: true, completion: nil)
                                                                  
                                                                }
                                    }
                                    
                                    
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
