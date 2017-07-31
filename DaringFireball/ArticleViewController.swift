//
//  ArticleViewController.swift
//  DaringFireball
//
//  Created by Tim Roesner on 7/30/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var html = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(html, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
