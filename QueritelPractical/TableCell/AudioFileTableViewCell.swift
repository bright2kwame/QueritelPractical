//
//  AudioFileTableViewCell.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import UIKit

class AudioFileTableViewCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    
    
    var feed: String? {
        didSet {
            guard let unwrapedItem = feed else {return}
            self.fileNameLabel.text = unwrapedItem
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
