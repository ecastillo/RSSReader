//
//  ArticleViewController.swift
//  RSSReader
//
//  Created by Eric Castillo on 4/29/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import UIKit
import FeedKit
import WebKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var webContent: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let feedURL = URL(string: "http://feeds.macrumors.com/MacRumors-All")!
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
                        self.articleTitle.text = feed.items?.first?.title
                        if let description = feed.items?.first?.description {
                            self.webContent.loadHTMLString(description, baseURL: nil)
                           // self.content.text = description
                        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
