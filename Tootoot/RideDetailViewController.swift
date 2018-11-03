//
//  RideDetailViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 27/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class RideDetailViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate {

    //MARK: Properties
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var remainingSeatsLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var yourDestinationTextField: UITextField!
    
    var ref: DatabaseReference!
    var ride: Ride?
    var driverId: String = ""
    var username: String = ""
    let locationManager = CLLocationManager()
    var locLat : Double = 0
    var locLong : Double = 0
    var location = CLLocation(latitude: 0, longitude: 0)
    var address: String = ""
    lazy var geocoder = CLGeocoder()
    var uid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Set up views if editing an existing Meal.
        if let ride = ride {
            driverLabel.text = ride.driver
            carLabel.text = ride.car
            beginLocationLabel.text = ride.beginLocation
            endLocationLabel.text = ride.destination
            startTimeLabel.text = ride.startTime
            remainingSeatsLabel.text = ride.seats
            commentsTextView.text = ride.comments
        }
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            print("locations = \(locLong) \(locLat)")
            
        }
        
        //Get current username
        if let user = Auth.auth().currentUser {
            uid = user.uid
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                print(value!)
                self.username = value?["username"] as? String ?? ""
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        self.title = "Ride Details"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendJoinRequestButton(_ sender: UIButton) {
        
        // Voeg Passenger toe aan lijst van Ride
        ref.child("rides").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                print("SNAPSHOT: \(snapshot)")
                
                for snap in snapshot {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if userDict["driver"] as? String == self.driverLabel.text {
                            self.driverId = snap.key
                            print(self.driverId)
                            //Add this key to userID array
                            
                            let name = self.username
                            let location = self.address
                            let destination = self.yourDestinationTextField.text
                            self.ref.child("rides").child(self.driverId).child("passengers").child(self.uid).setValue(["name": name, "location": location, "destination": destination!])
                            break
                        }
                    }
                }
            }
        })
        
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
    
}
