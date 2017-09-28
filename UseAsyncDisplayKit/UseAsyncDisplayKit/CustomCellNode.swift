//
//  CustomCellNode.swift
//  UseAsyncDisplayKit
//
//  Created by xuxiwen on 2017/9/28.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CustomCellNode: ASCellNode {

    let avatar =  ASNetworkImageNode()
    
    let contentTitle = ASTextNode()
    let contentSubTitle = ASTextNode()
    
    let avatarWidth:CGFloat = 70
    let margin:CGFloat = 10
    let textMinHeight:CGFloat = 0
    let textMaxHeight:CGFloat = 50

    let activityIndicator = ASDisplayNode.init(viewBlock: { () -> UIView in
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.backgroundColor = UIColor.clear
        view.hidesWhenStopped = true
        return view
    })

    
    override init() {
        super.init()
        self.selectionStyle = .none
        addSubnode(avatar)
        addSubnode(contentTitle)
        addSubnode(contentSubTitle)
        addSubnode(activityIndicator)
    }
    
    func resume() {
        startAnimating()
    }
    
    func startAnimating() {
        if let activityIndicatorView = activityIndicator.view as? UIActivityIndicatorView {
            activityIndicatorView.startAnimating()
        }
    }
 
    
    func setData(avatarUrlString : String, title : String , subTiltle: String) {
        if !avatarUrlString.isEmpty {
            avatar.url = URL.init(string: avatarUrlString)
        }
        if !title.isEmpty {
            contentTitle.attributedText = NSAttributedString(string: title, attributes:
                [NSAttributedStringKey.foregroundColor : UIColor.black,
                 NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                 NSAttributedStringKey.backgroundColor : UIColor.white]
            )
        }
        if !subTiltle.isEmpty {
            contentSubTitle.attributedText = NSAttributedString(string: subTiltle, attributes:
                [NSAttributedStringKey.foregroundColor : UIColor.black,
                 NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedStringKey.backgroundColor : UIColor.white]
            )
        }
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        
        let textWidth:CGFloat = XW_SCREEN_WIDTH - avatarWidth - margin * 3

        contentTitle.layoutThatFits(ASSizeRange.init(min: CGSize.init(width: textWidth, height: textMinHeight), max: CGSize.init(width: textWidth, height: textMaxHeight)))
        
        contentSubTitle.layoutThatFits(ASSizeRange.init(min: CGSize.init(width: textWidth, height: textMinHeight), max: CGSize.init(width: textWidth, height: textMaxHeight)))
        
        let calTitleHeight = contentTitle.calculatedSize.height
        let calSubTitleHeight = contentSubTitle.calculatedSize.height

        let textCalHeight = calTitleHeight + calSubTitleHeight + margin * 3
        let avatarDefault = avatarWidth + margin * 2
        
        if textCalHeight > avatarDefault {
            return CGSize.init(width: XW_SCREEN_WIDTH, height: textCalHeight)
        } else {
            return CGSize.init(width: XW_SCREEN_WIDTH, height: avatarDefault)
        }
     }
    
    override func layout() {
        
        let textWidth:CGFloat = XW_SCREEN_WIDTH - avatarWidth - margin * 3

       avatar.frame = CGRect.init(x: margin, y: margin, width: avatarWidth, height: avatarWidth)
       contentTitle.frame = CGRect.init(x: margin * 2 + avatarWidth, y: margin, width: textWidth, height: contentTitle.calculatedSize.height)
       contentSubTitle.frame = CGRect.init(x: margin * 2 + avatarWidth, y: margin * 2  + contentTitle.calculatedSize.height, width: textWidth, height: contentSubTitle.calculatedSize.height)
        
      activityIndicator.frame = CGRect(x: self.calculatedSize.width / 2.0 - 22.0, y: 11, width: 44, height: 44)
    }
}
