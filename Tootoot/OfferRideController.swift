//
//  OfferRideController.swift
//  Tootoot
//
//  Created by dervis kiratli on 22/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class OfferRideController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var comments: UITextView!
    var ref: DatabaseReference!
    var startTime : String = ""
    var endTime: String = ""
    let locationManager = CLLocationManager()
    var locLat : Double = 0
    var locLong : Double = 0
    var location = CLLocation(latitude: 0, longitude: 0)
    var address: String = ""
    var username: String = ""
    lazy var geocoder = CLGeocoder()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endLocation.delegate = self
        carTextField.delegate = self
        comments.delegate = self
        
        ref = Database.database().reference()
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            print("locations = \(locLong) \(locLat)")
            
        }
        
        location = CLLocation(latitude: locLat, longitude: locLong)
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                print(value!)
                self.username = value?["username"] as? String ?? ""
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        self.title = "Offer Ride"
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    deinit {
        //  stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
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
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    
    @IBAction func startTimeChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startTime = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func placeRide(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print(username)
            let endLocation = self.endLocation.text
            let car = self.carTextField.text
            let comments = self.comments.text
            
            self.ref.child("rides").child(uid).setValue(["driver":username,  "endLocation":endLocation!,"startTime": startTime,"car":car!,"comments":comments!, "longitude": locLong, "latitude": locLat, "address": address])
        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            address = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                address = placemark.compactAddress ?? "default value"
            } else {
                address = "No Matching Addresses Found"
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        carTextField.resignFirstResponder()
        endLocation.resignFirstResponder()
        comments.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if comments == view.window?.firstResponder {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardRect.height
            } else {
                view.frame.origin.y = 0
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endLocation.resignFirstResponder()
        carTextField.resignFirstResponder()
        return true
    }
    
}

extension CLPlacemark {
    
    var compactAddress: String? {
        var result: String = ""
        
      
        if let city = locality {
            result += "\(city)"
        }
        return result
    }
    
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}

