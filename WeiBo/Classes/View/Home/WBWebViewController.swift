//
//  WBWebViewController.swift
//  WeiBo
//
//  Created by HeYm on 2018/3/15.
//  Copyright © 2018年 HeYm. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {

    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    /// 要加载的 URL 字符串
    var urlString: String? {
        didSet {
            
            guard let urlString = urlString,
                let url = URL(string: urlString)
                else {
                    return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
}

extension WBWebViewController {
    
    override internal func setupTableView() {
        
        // 设置标题
        navItem.title = "网页"
        
        // 设置 webView
        view.insertSubview(webView, belowSubview: navigationBar)
        
        webView.backgroundColor = UIColor.white
        
        // 设置 contentInset
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
}

