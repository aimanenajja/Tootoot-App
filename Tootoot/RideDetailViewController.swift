//
//  RideDetailViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 27/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class RideDetailViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var remainingSeatsLabel: UILabel!    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var ride: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Meal.
        if let ride = ride {
            driverLabel.text = ride.driver
            carLabel.text = ride.car
            beginLocationLabel.text = ride.beginLocation
            endLocationLabel.text = ride.destination
            startTimeLabel.text = ride.startTime
            remainingSeatsLabel.text = ride.seats
        }
        
        self.title = "Ride Details"

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

}
