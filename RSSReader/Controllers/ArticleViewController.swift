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

class ArticleViewController: UIViewController {
    
    var article: RSSFeedItem?

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var webContent: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.articleTitle.text = article?.title
        if let description = article?.description {
            self.webContent.loadHTMLString(description, baseURL: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
