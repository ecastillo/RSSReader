//
//  ArticlesViewController.swift
//  RSSReader
//
//  Created by Eric Castillo on 4/29/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import FeedKit

class SourceViewController: UITableViewController {
    
    var feedURL: String = ""
    var articlesArray = [FeedKit.RSSFeedItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticles()

    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        cell.textLabel?.text = articlesArray[indexPath.row].title
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.article = articlesArray[indexPath.row]
        }
    }

    
    func loadArticles() {
        let feedURL = URL(string: self.feedURL)!
        if let parser = FeedParser(URL: feedURL) { // or FeedParser(data: data)
            // Parse asynchronously, not to block the UI.
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                // Do your thing, then back to the Main thread
                DispatchQueue.main.async {
                    // ..and update the UI
                    switch result {
                    case let .atom(feed): break       // Atom Syndication Format Feed Model
                    case let .rss(feed):        // Really Simple Syndication Feed Model
                        print("rss obtained!")
                        self.articlesArray = feed.items!
                        self.tableView.reloadData()
                    case let .json(feed):       // JSON Feed Model
                        print("json obtained!")
                    case let .failure(error):
                        print(error)
                    }
                }
            }
        } else {
            print("error parsing feed URL")
        }
    }
    

}
