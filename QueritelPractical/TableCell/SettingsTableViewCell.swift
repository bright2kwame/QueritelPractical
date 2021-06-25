//
//  SettingsTableViewCell.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var feed: SettingsItem? {
        didSet {
            guard let unwrapedItem = feed else {return}
            print(unwrapedItem.name)
            self.displayLabel?.text = unwrapedItem.name
            self.iconImageView?.image = UIImage(systemName: unwrapedItem.image)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
