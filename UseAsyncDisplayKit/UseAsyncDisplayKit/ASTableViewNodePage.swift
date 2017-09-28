//
//  ASTableViewNodePage.swift
//  UseAsyncDisplayKit
//
//  Created by xuxiwen on 2017/9/28.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ASTableViewNodePage: UIViewController,  ASTableDataSource, ASTableDelegate  {
    
    let tableView = ASTableNode.init(style: UITableViewStyle.plain)

    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orange
        tableView.dataSource = self
        tableView.delegate = self
        tableView.view.tableFooterView = UIView.init()
        self.view.addSubnode(tableView)
     }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK:- ASTableDataSource
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = CustomCellNode()
        if indexPath.row < mockData.count {
            let item = mockData[indexPath.row]
            let URLString = item[0]
            let title = item[1]
            let subTitle = item[2]
            cellNode.setData(avatarUrlString: URLString, title: title, subTiltle: subTitle)
            cellNode.startAnimating()
         }
        return cellNode
        
    }
    //MARK:-  ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < mockData.count {
            let item = mockData[indexPath.row]
            let title = item[1]
            debugPrint(title)
         }
    }
 
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
             (node as! CustomCellNode).resume()
 }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

