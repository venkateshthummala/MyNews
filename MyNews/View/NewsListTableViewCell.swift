//
//  NewsListTableViewCell.swift
//  MyNews
//
//  Created by ashish jain on 02/09/23.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var totalBv: UIView!
    
    @IBOutlet weak var newsPostImageView: UIImageView!
    
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
