//
//  ViewController.swift
//  UseAsyncDisplayKit
//
//  Created by xuxiwen on 2017/9/27.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Use AsyncDisplayKit"
    
        ///  Use ASTextNode
        buildTextNode(textContent: "Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !Hello, AsyncDisplayKit !")
     
       /// Use ASImageNode
         buildImageNode(imageURLString: "http://s1.dgtle.com/forum/201706/16/222435vgyp9ke8nje8kzqz.jpg")
        
        
       /// Use ASImageNode
        buildButtonNode(buttonName: "ASTableView 的编写。")
     }

    
    // MARK:- Use ASTextNode
    func buildTextNode(textContent: String)  {
        let textLabel = ASTextNode()
        if !textContent.isEmpty {
            textLabel.attributedText = NSAttributedString(string: textContent, attributes:
                [NSAttributedStringKey.foregroundColor : UIColor.white,
                 NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),
                 NSAttributedStringKey.backgroundColor : UIColor.black]
            )
        }

        let margin:CGFloat = 15
        let width:CGFloat = XW_SCREEN_WIDTH - margin * 2
        
        textLabel.layoutThatFits(ASSizeRange.init(min: CGSize.init(width: width, height: 30), max: CGSize.init(width: width, height: 300)))
        textLabel.frame = CGRect.init(x: margin, y: 90, width: textLabel.calculatedSize.width, height: textLabel.calculatedSize.height)
        
        self.view.addSubnode(textLabel)

    }
    
    // MARK:- Use ASImageNode
    func buildImageNode(imageURLString: String) {
        let imageView = ASNetworkImageNode()
        imageView.frame = CGRect.init(x: 80, y: 400, width: 200, height: 200)
        imageView.backgroundColor = UIColor.green
        imageView.contentMode = .scaleAspectFill
        if !imageURLString.isEmpty {
            imageView.url = URL.init(string: imageURLString)
        }
        self.view.addSubnode(imageView)
    }
    
    // MARK:- Use ASButtonNode
    func buildButtonNode(buttonName: String) {
        let buttonNode = ASButtonNode()
        if !buttonName.isEmpty {
            buttonNode.setTitle(buttonName, with: UIFont.systemFont(ofSize: 14), with: UIColor.black, for: UIControlState.normal)
        }
        buttonNode.backgroundColor = UIColor.yellow
        buttonNode.frame = CGRect.init(x: 80, y: 640, width: 200, height: 30)
        buttonNode.addTarget(self, action: #selector(clickedButton(sender:)), forControlEvents: .touchUpInside)
        self.view.addSubnode(buttonNode)
    }

    // MARK:- ASButtonNode Action
    @objc func clickedButton(sender: ASButtonNode)  {
        debugPrint("click")
        let tableNodePage = ASTableViewNodePage()
        self.navigationController?.pushViewController(tableNodePage, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

