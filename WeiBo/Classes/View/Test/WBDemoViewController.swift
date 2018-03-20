//
//  WBDemoViewController.swift
//  WeiBo
//
//  Created by HeYm on 2018/3/15.
//  Copyright © 2018年 HeYm. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
    }
    
    // MARK: - 监听方法
    /// 继续 PUSH 一个新的控制器
    @objc private func showNext() {
        
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoViewController {
    
    /// 重写父类方法
    override func setupTableView() {
        super.setupTableView()
        
        // 设置右侧的控制器
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
