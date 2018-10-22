//
//  AddCarController.swift
//  Tootoot
//
//  Created by dervis kiratli on 16/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddCarController: UIViewController {
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var carSeats: UITextField!
    @IBOutlet weak var carColour: UITextField!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addCarr(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let model = carModel.text
           self.ref.child("cars").child(uid).setValue(model)
            self.ref.child("cars").child(uid).child(model!).setValue(["Seats":carSeats.text,"Colour": carColour.text])
        }
        
    }
    
}
