//
//  ViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 2/10/18.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value)
            let username = value?["username"] as? String ?? ""
            
            self.usernameLabel.text = "Welkom, " + username
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.title = "Home"
        
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }

    
}
