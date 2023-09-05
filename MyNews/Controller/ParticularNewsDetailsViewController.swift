//
//  ParticularNewsDetailsViewController.swift
//  MyNews
//
//  Created by ashish jain on 02/09/23.
//

import UIKit
import Kingfisher

class ParticularNewsDetailsViewController: UIViewController {

    @IBOutlet weak var totalBackView: UIView!
    
    @IBOutlet weak var newsPostImageView: UIImageView!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    var newsDescription = ""
    var newsImageUrl:URL!
    var titleDescription = ""
    var publishedDate = ""
    var sourceName = ""
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var totalDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.newsPostImageView.kf.setImage(with: newsImageUrl!)

        self.descriptionLabel.text = titleDescription ?? ""
        self.totalDescriptionLabel.text = newsDescription ?? ""
        self.publishedDateLabel.text = publishedDate ?? ""
        self.sourceNameLabel.text = sourceName ?? ""

//        print(self.descriptionLabel.text!)
//        print(self.totalDescriptionLabel.text!)
//        print(self.publishedDateLabel.text!)

        
    }
    


}
