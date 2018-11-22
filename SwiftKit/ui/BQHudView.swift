//
//  BQHudView.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/19.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

class BQHudView: UIView {
    
    private var titleFont = UIFont.systemFont(ofSize: 16)
    private var title:String?
    private var info:String!
    private var infoFont = UIFont.systemFont(ofSize: 13)
    
    @discardableResult
    public class func show(supView: UIView, animation: Bool? = true, title: String? = nil) -> BQHudView {
        
        if let hudView = self.hudView(supView: supView) {
            hudView.removeFromSuperview()
        }
        
        let hudView = BQHudView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        hudView.title = title
        hudView.setUpUI()
        hudView.center = CGPoint(x: supView.sizeW * 0.5, y: supView.sizeH * 0.5)
        supView.addSubview(hudView)
        return hudView
    }
    
    public class func hide(supView: UIView, animation: Bool? = true) {
        
        if let hudView = self.hudView(supView: supView) {
            hudView.hide(animation: animation)
        }
        
    }
    
    public class func hudView(supView: UIView) -> BQHudView? {
        
        for view in supView.subviews.reversed() {
            if view is BQHudView {
                return view as? BQHudView
            }
        }
        
        return nil
    }
    
    public class func showMsg(info:String, title:String? = nil) {
        let msgView = BQHudView(frame: UIScreen.main.bounds, info: info, title: title)
        msgView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
        UIApplication.shared.keyWindow?.addSubview(msgView)
        msgView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            msgView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            msgView.removeFromSuperview()
        }
    }
    
    private convenience init(frame:CGRect, info:String, title:String?) {
        self.init(frame:frame)
        self.info = info
        self.title = title
        self.createContentView()
    }
    
    //MARK:- ***** instance method *****
    
    public func setUpUI() {
        self.backgroundColor = UIColor("e3e7e7")
        self.layer.cornerRadius = 8
        
        let activiView = UIActivityIndicatorView(style: .gray)
        activiView.startAnimating()
        activiView.center = CGPoint(x: self.sizeW * 0.5, y: self.sizeH * 0.5)
        activiView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.addSubview(activiView)
        
        if let text = self.title {
            let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 20))
            lab.font = infoFont
            lab.textColor = .gray
            lab.text = text
            lab.numberOfLines = 0
            lab.adjustHeightForFont(spacing: 10)
            self.addSubview(lab)
            if self.sizeW < lab.sizeW + 40 {
                self.sizeW = lab.sizeW + 40
            }
            if self.sizeH < lab.sizeH + activiView.sizeH + 20 {
                self.sizeH = lab.sizeH + activiView.sizeH + 20
            }
            activiView.center = CGPoint(x: self.sizeW * 0.5, y: self.sizeH * 0.5)
            lab.center = activiView.center
            activiView.top -= lab.sizeH * 0.5
            lab.top = activiView.bottom + 5
        }
        
    }
    
    public func hide(animation: Bool? = true) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = (animation! ? 0:1)
        }) { (finsh) in
            self.removeFromSuperview()
        }
        
    }
    
    private func createContentView() {
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
        let width = self.sizeW - 100
        var titleLab: UILabel?
        var maxWidth: CGFloat = 0
        
        if let title = self.title {
            let rect = title.boundingRect(with: CGSize(width: width, height: 100), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:self.titleFont], context: nil)
            let lab = UILabel(frame: rect)
            lab.numberOfLines = 0
            lab.font = UIFont.systemFont(ofSize: 16)
            lab.textColor = UIColor.white
            lab.text = title
            self.addSubview(lab)
            titleLab = lab
            maxWidth = lab.sizeW
        }
        
        let infoRect = self.info.boundingRect(with: CGSize(width: width, height: 100), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:self.infoFont], context: nil)
        let contentLab = UILabel(frame: infoRect)
        contentLab.numberOfLines = 0
        contentLab.text = self.info
        contentLab.font = UIFont.systemFont(ofSize: 15)
        contentLab.textColor = UIColor.white
        self.addSubview(contentLab)
        maxWidth = maxWidth > contentLab.sizeW ? maxWidth : contentLab.sizeW
        self.sizeW = maxWidth + 40
        
        if let lab = titleLab {
            self.sizeH = lab.sizeH + contentLab.sizeH + 50
            lab.center = CGPoint(x: self.sizeW * 0.5, y: 20 + lab.sizeH * 0.5)
            contentLab.center = CGPoint(x: self.sizeW * 0.5, y: lab.bottom + 10 + contentLab.sizeH * 0.5)
        }else {
            self.sizeH = contentLab.sizeH + 40;
            contentLab.center = CGPoint(x: self.sizeW * 0.5, y: 20 + contentLab.sizeH * 0.5)
        }
        self.setCorner(readius: 8)
    }
    
}
