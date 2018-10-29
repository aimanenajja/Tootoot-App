//
//  CurrentRideController.swift
//  Tootoot
//
//  Created by dervis kiratli on 22/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase

class CurrentRideController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var passengersTableView: UITableView!
    
    
    var ref: DatabaseReference!
    var refPassagiers: DatabaseReference!
    var passengers = [Passenger]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passengersTableView.delegate = self
        passengersTableView.dataSource = self
        
        ref = Database.database().reference()
        
        // om de destination mee te geven, kan eenvoudiger normaal
        let userID = Auth.auth().currentUser?.uid
        ref.child("rides").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value!)
            let destination = value?["endLocation"] as? String ?? ""
            
            self.destination.text = "Destination: " + destination
        }) { (error) in
            print(error.localizedDescription)
        }
        // om de tabel van passagiers te vullen
        
        refPassagiers = Database.database().reference().child("rides").child(userID!);
        
        refPassagiers.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.passengers.removeAll()
                
                //iterating through all the values
                for passengers in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    
                    if (passengers.value as? [String: AnyObject]) != nil {
                        let passengerObject = passengers.value as? [String: AnyObject]
                        let passengerName = passengerObject?["name"]
                        let passengerLocation = passengerObject?["location"]
                        let passengerDestination = passengerObject?["destination"]
                        
                        let passenger = Passenger(name: passengerName as! String, location: passengerLocation as! String, destination: passengerDestination as! String)
                        
                        //appending it to list
                        self.passengers.append(passenger!)
                    }
                    
                }
                
                //reloading the tableview
                self.passengersTableView.reloadData()
            }
        })
        
        self.title = "Current Ride"

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PassengerTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PassengerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PassengerTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let passenger = passengers[indexPath.row]
        
        //cell.distanceLabel.text = ride.distance //Dervis location impl
        cell.passengerNameLabel.text = passenger.name
        cell.passengerLocationLabel.text = passenger.location
        cell.passengerDestinationLabel.text = passenger.destination
        
        return cell
    }
    
}
