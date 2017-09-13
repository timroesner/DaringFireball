//
//  ViewController.swift
//  DaringFireball
//
//  Created by Tim Roesner on 7/30/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles = [String]()
    var externalURLs = [String]()
    var contents = [String]()
    var css = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Middle logo
        let middleBtn: UIButton = UIButton(type: UIButtonType.custom)
        middleBtn.setImage(UIImage(named: "logo"), for: UIControlState.normal)
        middleBtn.frame = CGRect(x: 0, y: 0, width: 172, height: 40)
        middleBtn.isUserInteractionEnabled = false
        let myView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 172, height: 40))
        myView.addSubview(middleBtn)
        self.navigationItem.titleView = myView
        
        NotificationCenter.default.addObserver(self, selector:#selector(parseJSON), name:NSNotification.Name.UIApplicationWillEnterForeground, object:UIApplication.shared
        )
        
        guard let fileURL = Bundle.main.url(forResource: "css", withExtension: "txt") else { return }
        do {
            css = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        parseJSON()
        
    }
    
    @objc func parseJSON(){
        SVProgressHUD.show()
        
        titles.removeAll()
        externalURLs.removeAll()
        contents.removeAll()
        
        let urlString = "https://daringfireball.net/feeds/json"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                print(error as Any)
                return
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    if let items = json?["items"] as? [[String: Any]] {
                        for item in items {
                            if let title = item["title"] as? String {
                                self.titles.append(title)
                                if let url =  item["external_url"] as? String {
                                    self.externalURLs.append(url)
                                } else {
                                    self.externalURLs.append("")
                                }
                                self.contents.append(item["content_html"] as! String)
                            }
                        }
                    }
                    // Get main thread and reload tableView
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SVProgressHUD.dismiss()
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = titles[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "ArticleView") as! ArticleViewController
            vc.html = "\(css) <a href='\(externalURLs[indexPath.row])'>\(titles[indexPath.row])</a> <br><br> \(contents[indexPath.row])"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

