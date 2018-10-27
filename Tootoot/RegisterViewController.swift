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

class RegisterViewController: UIViewController {

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
        ref = Database.database().reference()
        let email = defaults.string(forKey: "Email")
        if !(email == "") && self.remember.isOn{
            emailTextField.text = email}
<<<<<<< HEAD
        self.navigationController?.setNavigationBarHidden(false, animated: false)
=======
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
>>>>>>> 23961090af3f85f752bd82a794c4f1c7f91a75ab
        
        self.title = "Tootoot"
        // Do any additional setup after loading the view.
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
                    self.defaults.set(email, forKey: " ")
                }
                
                if authDataResult != nil {
                    
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


