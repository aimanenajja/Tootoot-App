//
//  RegisterViewController.swift
//  Tootoot
//
//  Created by dervis kiratli on 06/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {

      var ref: DatabaseReference!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var remember: UISwitch!
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameField: UIStackView!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let defaults = UserDefaults.standard
        ref = Database.database().reference()
        let email = defaults.string(forKey: "Email")
        if let remember = UserDefaults.standard.value(forKey: "Remember")
        {
            if remember as! Bool {
                self.remember.isOn = true
            } else {
               self.defaults.set("", forKey: "Email")
            }
            
        } else {
            self.defaults.set(false, forKey: "Remember")
            self.defaults.set("", forKey: "Email")
        }
        if !(email == ""){
            emailTextField.text = email}
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Tootoot"
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    deinit {
        //  stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn{
            signInLabel.text = "Sign In"
            nameField.isHidden = true; signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            signInLabel.text = "Register"
            nameField.isHidden = false; signInButton.setTitle("Register", for: .normal)
        }
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text{
            
        if isSignIn{
            Auth.auth().signIn(withEmail: email, password: pass) { (authDataResult: AuthDataResult?  , error) in
                
                if self.remember.isOn{
                    self.defaults.set(email, forKey: "Email")
                } else {
                    self.defaults.set(" ", forKey: "Email")
                }
                
                if let user = authDataResult {
                    
                    self.performSegue(withIdentifier: "signInSuccesful", sender: self)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                }
            }
            
        
        else {
            Auth.auth().createUser(withEmail: email, password: pass) { (authDataResult: AuthDataResult?, error) in
                if let user = authDataResult {
                    
                   let userUid = user.user.uid
                   let email = user.user.email
                    
                    if self.remember.isOn{
                        self.defaults.set(email, forKey: "Email")
                    } else {
                        self.defaults.set(" ", forKey: "Email")
                    }
                    let name = self.usernameTextField.text
                    self.ref.child("users").child(userUid).setValue(["email": email, "username": name ])
                    
                    self.performSegue(withIdentifier: "signInSuccesful", sender: self)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            }
        }
        }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
}
    @IBAction func rememberEmail(_ sender: UISwitch) {
        if remember.isOn{
            self.defaults.set(true, forKey: "Remember")
        } else {
            self.defaults.set(false, forKey: "Remember")
        }
    }
    
    // UITextFieldDelegate Methods
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if UIDevice.current.orientation.isLandscape {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardRect.height
            } else {
                view.frame.origin.y = 0
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


