//
//  PassengerTableViewCell.swift
//  Tootoot
//
//  Created by Aïmane Najja on 29/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class PassengerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var passengerLocationLabel: UILabel!
    @IBOutlet weak var passengerDestinationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
