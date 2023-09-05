//
//  NewsListTableViewCell.swift
//  MyNews
//
//  Created by ashish jain on 02/09/23.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var totalBv: UIView!
    
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var newsPostImageView: UIImageView!
    
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    @IBOutlet weak var publishedDateAndTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.totalBv.layer.cornerRadius = 10
        self.totalBv.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
