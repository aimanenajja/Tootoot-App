//
//  OfferRideController.swift
//  Tootoot
//
//  Created by dervis kiratli on 22/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase

class OfferRideController: UIViewController {
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var comments: UITextView!
    var ref: DatabaseReference!
    var startTime : String = ""
    var endTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTimeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        startTime = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func endTimeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        endTime = dateFormatter.string(from: sender.date)
    }
    @IBAction func placeRide(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let endLocation = self.endLocation.text
            let car = self.carTextField.text
            let comments = self.comments.text
            
            
            self.ref.child("rides").child(uid).setValue(["endLocation":endLocation, "endTime": endTime,"startTime": startTime,"car":car,"comments":comments])
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

}
