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
<<<<<<< HEAD
=======
    let locationManager = CLLocationManager()
    var locLat : Double = 0
    var locLong : Double = 0
    var location : CLLocation
    var address: String = ""
>>>>>>> 036f05e719a99851acf6edc2d0223fb83c18a220
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
<<<<<<< HEAD
=======
<<<<<<< HEAD
        
=======
<<<<<<< HEAD
        
        self.title = "Offer Ride"
=======
        self.locationManager.requestWhenInUseAuthorization()
>>>>>>> f6b930aa7c91c82201eec945a4ffbf87cb77afbc
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            
            }
        }
        
>>>>>>> 036f05e719a99851acf6edc2d0223fb83c18a220

        // Do any additional setup after loading the view.
<<<<<<< HEAD
    }
=======
    
    


    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locLong = locValue.longitude
        locLat = locValue.latitude
        location = CLLocation(latitude: locLat, longitude: locLong)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
>>>>>>> 036f05e719a99851acf6edc2d0223fb83c18a220
    
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
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil{
            print("failed")
            return
        }
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0] as! CLPlacemark!
                adress = (pm?.subThoroughfare)! + " " + (pm?.thoroughfare) + " " + (pm?.locality)! + "," + (pm?.administrativeArea)! + " " + (pm?.postalCode)! + " " + (pm?.isoCountryCode)!
            })

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
<<<<<<< HEAD

=======
		



}
>>>>>>> 036f05e719a99851acf6edc2d0223fb83c18a220
}
