//
//  WBBaseViewController.swift
//  WeiBo
//
//  Created by HeYm on 2017/12/7.
//  Copyright © 2017年 HeYm. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WBBaseViewController: UIViewController {
    /// 访客视图信息字典
    var visitorInfoDictionary: [String: String]?
    
    /// 表格视图 - 如果用户没有登录，就不创建
    var tableView: UITableView?
    /// 刷新控件
    var refreshControl: CZRefreshControl?
    /// 上拉刷新标记
    var isPullup = false
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    /// 自定义的导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        // 注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loginSuccess),
            name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification),
            object: nil)
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 重写 title 的 didSet
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类负责
    @objc func loadData() {
        // 如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }
}

// MARK: - 访客视图监听方法
extension WBBaseViewController {
    
    /// 登录成功处理
    @objc private func loginSuccess(n: Notification) {
        
        print("登录成功 \(n)")
        
        // 登录前左边是注册，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新 UI => 将访客视图替换为表格视图
        // 需要重新设置 view
        // 在访问 view 的 getter 时，如果 view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func login() {
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register() {
        print("用户注册")
    }
}

// MARK: - 设置界面
extension WBBaseViewController {
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
//        automaticallyAdjustsScrollViewInsets = false
        
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
        
        setupNavigationBar()
    }
    
    /// 设置表格视图 - 用户登录之后执行
    /// 子类重写此方法，因为子类不需要关心用户登录之前的逻辑
    @objc func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源&代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                               left: 0,
                                               bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                               right: 0)
        
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        // 设置刷新控件
        // 1> 实例化控件
        refreshControl = CZRefreshControl()
        
        // 2> 添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        // 3> 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        
        let visitorView = WBVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        // print("访客视图 \(visitorView)")
        
        // 1. 设置访客视图信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        // 2. 添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 3. 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        
//        if #available(iOS 11, *) {
////            let insets = self.view.safeAreaInsets
//            navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.cz_screenWidth(), height: 64)
//        }
        // 添加导航条
        
        
        let navigationBarContainerView = UIView()
        // configure the container view
        navigationBarContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(navigationBarContainerView)
        navigationBarContainerView.addSubview(navigationBar)
        
        navigationBarContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { make in
            // iOS 11 and SnapKit 4.0
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                // iOS 10，如果没有升级 SnapKit 的话，可以使用 topLayoutGuide
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            make.bottom.leading.trailing.equalToSuperview()
        }
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        
        // 1> 设置 navBar 整个背景的渲染颜色
        navigationBar.barTintColor = UIColor.white
        // 2> 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // 基类只是准备方法，子类负责具体的实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只是保证没有语法错误！
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    /// 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. 判断 indexPath 是否是最后一行
        // (indexPath.section(最大) / indexPath.row(最后一行))
        // 1> row
        let row = indexPath.row
        // 2> section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        // 3> 行数
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，同时没有开始上拉刷新
        if row == (count - 1) && !isPullup {
            
            print("上拉刷新")
            isPullup = true
            
            // 开始刷新
            loadData()
        }
    }
}
