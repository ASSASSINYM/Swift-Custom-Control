// *******************************************
//  File Name:      UIViewController+BQExtension.swift       
//  Author:         MrBai
//  Created Date:   2019/8/15 2:16 PM
//    
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************
    

import UIKit

extension UIViewController {
    
    var navBarBottom: CGFloat {
        get {
            return self.navigationController?.navigationBar.bottom ?? 0
        }
    }
    
    var tabBarSizeH: CGFloat {
        get {
            return self.tabBarController?.tabBar.sizeH ?? 0
        }
    }
    
    class func currentVc() -> UIViewController? {
        var vc = UIApplication.shared.keyWindow?.rootViewController
        while let presentVc = vc?.presentedViewController {
            vc = presentVc
        }
        return vc
    }
    
}
