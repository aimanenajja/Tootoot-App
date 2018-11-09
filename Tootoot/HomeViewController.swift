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
    @IBOutlet weak var joinRideButton: UIButton!
    @IBOutlet weak var offerRideButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var myProfileLabel: UIBarButtonItem!
    @IBOutlet weak var logOutLabel: UIBarButtonItem!
    
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value!)
            let username = value?["username"] as? String ?? ""
            
            self.usernameLabel.text = "Welkom, " + username
        }) { (error) in
            print(error.localizedDescription)
        }
        self.title = "Home"

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
            self.usernameLabel.frame.size.height = self.usernameLabel.frame.height * 2
            self.usernameLabel.font = self.usernameLabel.font.withSize(self.usernameLabel.font.pointSize * 2)
            self.joinRideButton.frame.size.height = self.joinRideButton.frame.height * 2
            self.joinRideButton.titleLabel?.font = self.joinRideButton.titleLabel?.font.withSize((self.joinRideButton.titleLabel?.font.pointSize)!*2)
            self.offerRideButton.frame.size.height = self.offerRideButton.frame.height * 2
            self.offerRideButton.titleLabel?.font = self.offerRideButton.titleLabel?.font.withSize((self.offerRideButton.titleLabel?.font.pointSize)!*2)
        } else {
            print("Portrait")
            self.usernameLabel.frame.size.height = self.usernameLabel.frame.height / 2
            self.usernameLabel.font = self.usernameLabel.font.withSize(self.usernameLabel.font.pointSize / 2)
            self.joinRideButton.frame.size.height = self.joinRideButton.frame.height / 2
            self.joinRideButton.titleLabel?.font = self.joinRideButton.titleLabel?.font.withSize((self.joinRideButton.titleLabel?.font.pointSize)! / 2)
            self.offerRideButton.frame.size.height = self.offerRideButton.frame.height / 2
            self.offerRideButton.titleLabel?.font = self.offerRideButton.titleLabel?.font.withSize((self.offerRideButton.titleLabel?.font.pointSize)! / 2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }

    
}

