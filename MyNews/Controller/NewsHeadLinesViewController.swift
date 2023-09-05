//
//  NewsHeadLinesViewController.swift
//  MyNews
//
//  Created by ashish jain on 02/09/23.
//

import UIKit
import Kingfisher


class NewsHeadLinesViewController: UIViewController {

    @IBOutlet weak var totalBv: UIView!
    
    @IBOutlet weak var newsListTvBackView: UIView!
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    
    var articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.newsListTableView.delegate = self
        self.newsListTableView.dataSource = self
        self.newsListTableView.register(UINib(nibName: "NewsListTableViewCell", bundle: .main), forCellReuseIdentifier: "NewsListTableViewCell")
        newsDataApiCalling()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func newsDataApiCalling() {
            guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=b8e09686a60644c2b43c917473c00d10") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    self?.articles = response.articles
                    
                    print(self?.articles)
                    // Reload the table view on the main thread
                    DispatchQueue.main.async {
                        self?.newsListTableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    

}
extension NewsHeadLinesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.newsListTableView.dequeueReusableCell(withIdentifier: "NewsListTableViewCell", for: indexPath) as!NewsListTableViewCell
        
            let article = articles[indexPath.row]
               // cell.titleLabel.text = article.title
                cell.newsDescriptionLabel.text = article.title ?? ""
        cell.sourceNameLabel.text = article.source.name ?? ""
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Assuming the input format is in ISO 8601

        if !article.publishedAt.isEmpty {
            if let date = dateFormatter.date(from: article.publishedAt) {
                dateFormatter.dateFormat = "yyyy-MM-dd" // Format to display only the date portion
                let formattedDate = dateFormatter.string(from: date)
                cell.publishedDateAndTimeLabel.text = formattedDate
            } else {
                cell.publishedDateAndTimeLabel.text = "Invalid date format"
            }
        } else {
            cell.publishedDateAndTimeLabel.text = "Date not available"
        }
       // cell.publishedDateAndTimeLabel.text = article.publishedAt ?? "''"
        

        DispatchQueue.main.async {
            if let urlString = self.articles[indexPath.row].urlToImage {
                let encodedURLString = urlString.replacingOccurrences(of: " ", with: "%20")
                if let url = URL(string: encodedURLString) {
                    print(url)
                    cell.newsPostImageView.kf.setImage(with: url)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async { [self] in
            if let urlString = self.articles[indexPath.row].urlToImage {
                let encodedURLString = urlString.replacingOccurrences(of: " ", with: "%20")
                if let url = URL(string: encodedURLString) {
                    print(url)

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParticularNewsDetailsViewController") as!ParticularNewsDetailsViewController
                    vc.newsImageUrl = url
                    vc.titleDescription = self.articles[indexPath.row].title ?? ""
                    vc.newsDescription = self.articles[indexPath.row].description ?? ""
                    vc.publishedDate = self.articles[indexPath.row].publishedAt ?? ""
                    vc.sourceName = self.articles[indexPath.row].source.name ?? ""
                    
                    let article = articles[indexPath.row]
                       
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Assuming the input format is in ISO 8601

                if !article.publishedAt.isEmpty {
                    if let date = dateFormatter.date(from: article.publishedAt) {
                        dateFormatter.dateFormat = "yyyy-MM-dd" // Format to display only the date portion
                        let formattedDate = dateFormatter.string(from: date)
                        vc.publishedDate = formattedDate
                    } else {
                        vc.publishedDate = " "
                    }
                } else {
                }
                    
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
        }
    }
}
