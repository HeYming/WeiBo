//
//  WBProfileViewController.swift
//  WeiBo
//
//  Created by HeYm on 2017/12/7.
//  Copyright © 2017年 HeYm. All rights reserved.
//

import UIKit

class WBProfileViewController: WBBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 模拟 token 过期
        // WBNetworkManager.shared.userAccount.access_token = "hello token"
        
        print("修改了 token")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

