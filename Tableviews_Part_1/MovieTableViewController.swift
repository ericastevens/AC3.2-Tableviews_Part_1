//
//  MovieTableViewController.swift
//  Tableviews_Part_1
//
//  Created by Erica Y Stevens on 9/25/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    internal var movieData: [Movie]?
    
    internal let rawMovieData: [[String : Any]] = movies
    let cellIdentifier: String = "MovieTableViewCell"
    
    enum Genre: Int {
        case animation
        case action
        case drama
    }
    
    enum Century: Int {
        case twentiethCentury
        case twentyFirstCentury
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        self.tableView.backgroundColor = UIColor.purple
        
        // converting from array of dictionaries
        // to an array of Movie structs
        var movieContainer: [Movie] = []
        for rawMovie in rawMovieData {
            movieContainer.append(Movie(from: rawMovie))
        }
        movieData = movieContainer
    }
    
    func byCentury(_ year: Century) -> [Movie]? {
        
        let cFilter: (Movie) -> Bool
        switch year {
        case .twentiethCentury:
            cFilter = { (a) -> Bool in
                1901...2000 ~= a.year
            }
        case .twentyFirstCentury:
            cFilter = { (a) -> Bool in
                2001...2100 ~= a.year
            }
        }
        
        // after filtering, sort
        let filtered = movieData?.filter(cFilter).sorted {  $0.year < $1.year }
        
        return filtered
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let century = Century.init(rawValue: section), let data = byCentury(century)
            else {
                return 0
        }
        
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        guard let century = Century.init(rawValue: indexPath.section), let data = byCentury(century)
            else {
                return cell
        }
        
        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = String(data[indexPath.row].year)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let century = Century.init(rawValue: section) else {
            return "" }
        
        switch century {
        case .twentiethCentury:
            return "20th Century"
        case .twentyFirstCentury:
            return "21st Century"
        }
    }
}
