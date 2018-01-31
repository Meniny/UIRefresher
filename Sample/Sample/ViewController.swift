//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2018-01-30.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import UIKit
import UIRefresher

class ViewController: UITableViewController {
    let ori = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var data: [Int] = [
        1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setRefreshHeader(.indicator, height: 60) {
            self.refresh()
        }
        tableView.setLoadMoreFooter(.indicator, height: 60) {
            self.loadmore()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.tableView.endRefreshing()
            self.data.removeAll()
            self.data.append(contentsOf: self.ori)
            self.tableView.reloadData()
            print("Refresh")
        })
    }
    
    func loadmore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.tableView.endRefreshing()
            self.data.append(contentsOf: self.ori)
            self.tableView.reloadData()
            print("Load More")
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        let d = self.data[indexPath.row]
        cell?.textLabel?.text = "\(indexPath.row + 1)/\(self.data.count)"
        cell?.textLabel?.textColor = UIColor.black
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

