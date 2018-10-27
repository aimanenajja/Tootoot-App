//
//  JoinRideViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import os.log
import Firebase

class JoinRideTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var rides = [Ride]()
    @IBOutlet var JoinRideTableView: UITableView!
    
    //MARK: Database References
    var refRides: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refRides = Database.database().reference().child("rides");
        
        //observing the data changes
        refRides.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.rides.removeAll()
                
                //iterating through all the values
                for rides in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let rideObject = rides.value as? [String: AnyObject]
                    //let rideDriver = rideObject?["driver"]
                    let rideCar = rideObject?["car"]
                    let rideBeginLocation = rideObject?["address"]
                    let rideDestination = rideObject?["endLocation"]
                    let rideStartTime = rideObject?["startTime"]
                    //let rideSeats = rideObject?["seats"]
                    let rideComments = rideObject?["comments"]
                    
                    let ride = Ride(driver: "Emre", car: rideCar as! String, beginLocation: rideBeginLocation as! String, destination: rideDestination as! String, startTime: rideStartTime as! String, seats: "4", comments: rideComments as! String)
                    
                    //appending it to list
                    self.rides.append(ride!)
                }
                
                //reloading the tableview
                self.JoinRideTableView.reloadData()
            }
        })
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Launchscreen"))
        self.title = "Join Ride"
        
        // Load the sample data.
        //loadSampleRides()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RideTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RideTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RideTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let ride = rides[indexPath.row]
        
        //cell.distanceLabel.text = ride.distance //Dervis location impl
        cell.startTimeLabel.text = ride.startTime
        cell.destinationLabel.text = ride.destination
        cell.seatsLabel.text = ride.seats
        
        return cell
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let rideDetailViewController = segue.destination as? RideDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedRideCell = sender as? RideTableViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedRideCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedRide = rides[indexPath.row]
        rideDetailViewController.ride = selectedRide
    }
    
    //MARK: Private Methods
    private func loadSampleRides() {
//        guard let ride1 = Ride(driver: "Emre", car: "Hyundai i30", beginLocation: "Mol", destination: "Hasselt", startTime: "07:00u", seats: "4") else {
//            fatalError("Unable to instantiate ride1")
//        }
//        guard let ride2 = Ride(driver: "Burak", car: "Renault Clio", beginLocation: "Maasmechelen", destination: "Hasselt", startTime: "07:30u", seats: "4") else {
//            fatalError("Unable to instantiate ride1")
//        }
//        guard let ride3 = Ride(driver: "Deniz", car: "BMW 118d", beginLocation: "Beringen", destination: "Hasselt", startTime: "07:30u", seats: "4") else {
//            fatalError("Unable to instantiate ride1")
//        }
//
//        rides += [ride1, ride2, ride3]

    }
    
}
